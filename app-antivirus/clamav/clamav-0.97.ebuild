# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils flag-o-matic

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="http://www.clamav.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="bzip2 clamdtop iconv ipv6 milter selinux test"

CDEPEND="bzip2? ( app-arch/bzip2 )
	clamdtop? ( sys-libs/ncurses )
	milter? ( || ( mail-filter/libmilter mail-mta/sendmail ) )
	iconv? ( virtual/libiconv )
	>=sys-libs/zlib-1.2.2
	dev-libs/libtommath"

DEPEND="${CDEPEND}
	>=dev-util/pkgconfig-0.20
	test? ( dev-libs/check )"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-clamav )"

pkg_setup() {
	enewgroup clamav
	enewuser clamav -1 -1 /dev/null clamav
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.97-nls.patch
}

src_configure() {
	econf  \
		--disable-experimental \
		--enable-id-check \
		--with-dbdir=/var/lib/clamav \
		$(use_enable bzip2) \
		$(use_enable test check) \
		$(use_enable clamdtop) \
		$(use_enable ipv6) \
		$(use_enable milter) \
		$(use_with iconv) \
		--with-system-tommath \
		--without-libpdcurses-prefix \
		--disable-zlib-vcheck
}

src_install() {
	emake DESTDIR="${D}" install || die
	rm -rf "${D}"/var/lib/clamav
	dodoc AUTHORS BUGS ChangeLog FAQ INSTALL NEWS README UPGRADE || die

	newconfd "${FILESDIR}/clamd.conf" clamd || die
	newinitd "${FILESDIR}/clamd.rc" clamd || die
	newconfd "${FILESDIR}/freshclam.conf" freshclam || die
	newinitd "${FILESDIR}/freshclam.rc" freshclam || die
	if use milter; then
		newconfd "${FILESDIR}/clamav-milter.conf" clamav-milter || die
		newinitd "${FILESDIR}/clamav-milter.rc" clamav-milter || die
	fi

	for dir in lib run log; do
		keepdir /var/${dir}/clamav || die "Can't create /var/${dir}/clamav"
		fowners clamav:clamav /var/${dir}/clamav || die
	done

	# Modify /etc/{clamd,freshclam}.conf to be usable out of the box
	sed -i -e "s:^\(Example\):\# \1:" \
		-e "s:.*\(PidFile\) .*:\1 /var/run/clamav/clamd.pid:" \
		-e "s:.*\(LocalSocket\) .*:\1 /var/run/clamav/clamd.sock:" \
		-e "s:.*\(User\) .*:\1 clamav:" \
		-e "s:^\#\(LogFile\) .*:\1 /var/log/clamav/clamd.log:" \
		-e "s:^\#\(LogTime\).*:\1 yes:" \
		-e "s:^\#\(AllowSupplementaryGroups\).*:\1 yes:" \
		"${D}"/etc/clamd.conf || die
	sed -i -e "s:^\(Example\):\# \1:" \
		-e "s:.*\(PidFile\) .*:\1 /var/run/clamav/freshclam.pid:" \
		-e "s:.*\(DatabaseOwner\) .*:\1 clamav:" \
		-e "s:^\#\(UpdateLogFile\) .*:\1 /var/log/clamav/freshclam.log:" \
		-e "s:^\#\(NotifyClamd\).*:\1 /etc/clamd.conf:" \
		-e "s:^\#\(ScriptedUpdates\).*:\1 yes:" \
		-e "s:^\#\(AllowSupplementaryGroups\).*:\1 yes:" \
		"${D}"/etc/freshclam.conf || die

	if use milter; then
		# And again same for /etc/clamav-milter.conf
		# MilterSocket one to include ' /' because there is a 2nd line for
		# inet: which we want to leave
		dodoc "${FILESDIR}"/clamav-milter.README.gentoo || die

		sed -i -e "s:^\(Example\):\# \1:" \
			-e "s:.*\(PidFile\) .*:\1 /var/run/clamav/clamav-milter.pid:" \
			-e "s+^\#\(ClamdSocket\) .*+\1 unix:/var/run/clamav/clamd.sock+" \
			-e "s:.*\(User\) .*:\1 clamav:" \
			-e "s+^\#\(MilterSocket\) /.*+\1 unix:/var/run/clamav/clamav-milter.sock+" \
			-e "s:^\#\(AllowSupplementaryGroups\).*:\1 yes:" \
			-e "s:^\#\(LogFile\) .*:\1 /var/log/clamav/clamav-milter.log:" \
			"${D}"/etc/clamav-milter.conf || die
	fi

	if use milter ; then
		cat << EOF >> "${D}"/etc/conf.d/clamd || die
MILTER_NICELEVEL=19
START_MILTER=no
EOF
	fi

	diropts ""
	dodir /etc/logrotate.d || die
	insopts -m0644
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN} || die
}

pkg_postinst() {
	ewarn
	ewarn "Since clamav-0.97, signatures are not installed anymore. If you are"
	ewarn "installing for the first time or upgrading from a version older"
	ewarn "than clamav-0.97 you must download the newest signatures by"
	ewarn "executing: /usr/bin/freshclam"
	ewarn

	if use milter ; then
		elog "For simple instructions how to setup the clamav-milter read the"
		elog "clamav-milter.README.gentoo in /usr/share/doc/${PF}"
	fi
}
