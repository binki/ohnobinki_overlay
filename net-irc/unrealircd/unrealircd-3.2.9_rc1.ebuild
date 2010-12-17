# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/unrealircd/unrealircd-3.2.8.1.ebuild,v 1.5 2009/12/22 01:01:06 vostorga Exp $

EAPI=2

inherit eutils autotools ssl-cert versionator multilib

MY_P=Unreal$(replace_version_separator 3 -)

DESCRIPTION="An advanced Internet Relay Chat daemon"
HOMEPAGE="http://www.unrealircd.com/"
SRC_URI="http://www.unrealircd.com/downloads/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="curl ipv6 +extban-stacking +operoverride +nospoof operoverride-verify +prefixaq
	showlistmodes shunnotices ssl topicisnuhost +usermod zlib"

RDEPEND="ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )
	curl? ( net-misc/curl )
	dev-libs/libstrl
	dev-libs/tre
	>=net-dns/c-ares-1.6.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/Unreal$(get_version_component_range 1-2)

AT_M4DIR=autoconf/m4

pkg_setup() {
	enewuser unrealircd || die
}

src_prepare() {
	# QA check against bundled pkgs
	rm extras/*.gz || die

	sed -i \
		-e "s:ircd\.pid:/var/run/unrealircd/ircd.pid:" \
		-e "s:ircd\.log:/var/log/unrealircd/ircd.log:" \
		-e "s:debug\.log:/var/log/unrealircd/debug.log:" \
		-e "s:ircd\.tune:/var/lib/unrealircd/ircd.tune:" \
		include/config.h \
		|| die "sed failed"

	# My own anti-replication of strlcpy()/strlcat(). --binki
	epatch "${FILESDIR}"/${P}-libstrl.patch

	# Support DESTDIR= for emake install
	epatch "${FILESDIR}"/${P}-destdir.patch

	eautoreconf
}

src_configure() {
	local myconf=""

	# Many unrealircd options don't support the --disable/--without
	# variation.
	use curl     && myconf="${myconf} --enable-libcurl=/usr"
	use zlib     && myconf="${myconf} --enable-ziplinks"
	use ssl      && myconf="${myconf} --enable-ssl"

	econf \
		--with-listen=5 \
		--with-dpath=/etc/unrealircd \
		--with-spath=/usr/bin/unrealircd \
		--with-nick-history=2000 \
		--with-sendq=3000000 \
		--with-bufferpool=18 \
		--with-permissions=0600 \
		--with-fd-setsize=1024 \
		--with-system-cares \
		--with-system-tre \
		--enable-dynamic-linking \
		$(use_enable ipv6 inet6) \
		$(use_enable prefixaq) \
		$(use_enable nospoof) \
		$(use_with showlistmodes) \
		$(use_with topicisnuhost) \
		$(use_with shunnotices) \
		$(use_with \!operoverride no-operoverride) \
		$(use_with operoverride-verify) \
		$(use_with \!usermod disableusermod) \
		$(use_with \!extban-stacking disable-extendedban-stacking) \
		${myconf}
}

src_compile() {
	emake DESTDIR="${D}" || die
}

src_install() {
	keepdir /var/{lib,log,run}/unrealircd

	newbin src/ircd unrealircd || die

	exeinto /usr/$(get_libdir)/unrealircd/modules
	doexe src/modules/*.so || die

	dodir /etc/unrealircd
	dosym /var/lib/unrealircd /etc/unrealircd/tmp || die

	insinto /etc/unrealircd
	doins {badwords.*,help,spamfilter,dccallow}.conf || die
	newins doc/example.conf unrealircd.conf || die

	insinto /etc/unrealircd/aliases
	doins aliases/*.conf || die
	insinto /etc/unrealircd/networks
	doins networks/*.network || die

	sed -i \
		-e s:src/modules:/usr/$(get_libdir)/unrealircd/modules: \
		-e s:ircd\\.log:/var/log/unrealircd/ircd.log: \
		"${D}"/etc/unrealircd/unrealircd.conf \
		|| die

	dodoc \
		Changes Donation Unreal.nfo networks/makenet \
		ircdcron/{ircd.cron,ircdchk} \
		|| die "dodoc failed"
	dohtml doc/*.html || die

	newinitd "${FILESDIR}"/unrealircd.rc unrealircd || die
	newconfd "${FILESDIR}"/unrealircd.confd unrealircd || die

	fperms 700 /etc/unrealircd || die
	chown -R unrealircd "${D}"/{etc,var/{lib,log,run}}/unrealircd ||die
}

pkg_postinst() {
	# Move docert call from scr_install() to install_cert in pkg_postinst for
	# bug #201682
	if use ssl ; then
		if [[ ! -f "${ROOT}"/etc/unrealircd/server.cert.key ]]; then
			install_cert /etc/unrealircd/server.cert || die
			chown unrealircd "${ROOT}"/etc/unrealircd/server.cert.* || die
			ln -snf server.cert.key "${ROOT}"/etc/unrealircd/server.key.pem || die
		fi
	fi

	elog
	elog "UnrealIRCd will not run until you've set up /etc/unrealircd/unrealircd.conf"
	elog
	elog "You can find example cron scripts here:"
	elog "   /usr/share/doc/${PF}/ircd.cron.gz"
	elog "   /usr/share/doc/${PF}/ircdchk.gz"
	elog
	elog "You can also use /etc/init.d/unrealircd to start at boot"
	elog
}
