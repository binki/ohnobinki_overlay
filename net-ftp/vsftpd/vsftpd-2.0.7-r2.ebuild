# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/vsftpd/vsftpd-2.0.7-r1.ebuild,v 1.6 2009/01/02 16:33:32 cla Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Very Secure FTP Daemon written with speed, size and security in mind"
HOMEPAGE="http://vsftpd.beasts.org/"
SRC_URI="ftp://vsftpd.beasts.org/users/cevans/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="caps pam tcpd ssl selinux xinetd"

DEPEND="caps? ( sys-libs/libcap )
	pam? ( virtual/pam )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	ssl? ( >=dev-libs/openssl-0.9.7d )"
RDEPEND="${DEPEND}
	net-ftp/ftpbase
	selinux? ( sec-policy/selinux-ftpd )
	xinetd? ( sys-apps/xinetd )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Patch the source, config and the manpage to use /etc/vsftpd/
	epatch "${FILESDIR}/${PN}-2.0.3-gentoo.patch"
	# uclibc fix, from Debian
	epatch "${FILESDIR}"/${PN}-2.0.7-uclibc.patch

	# Fix building without the libcap
	epatch "${FILESDIR}/${PN}-2.0.6-caps.patch"
	has_version "<sys-libs/libcap-2" && epatch "${FILESDIR}"/${PN}-2.0.6-libcap1.patch

	# Configure vsftpd build defaults
	echo "#!/bin/sh" > vsf_findlibs.sh
	if use tcpd; then
		echo "#define VSF_BUILD_TCPWRAPPERS" >> builddefs.h
		echo "echo \"-lwrap\" \"-lnsl\"" >> vsf_findlibs.sh
	fi
	if use ssl; then
		echo "#define VSF_BUILD_SSL" >> builddefs.h
		echo "echo \"-lssl -lcrypto\"" >> vsf_findlibs.sh
	fi
	if use pam; then
		echo "\"-lpam\"" >> vsf_findlibs.sh
	else
		echo "#undef VSF_BUILD_PAM" >> builddefs.h
	fi

	# Ensure that we don't link against libcap unless asked
	if use caps ; then
		echo "echo \"-lcap\"" >> vsf_findlibs.sh
	else
		sed -i '/^#define VSF_SYSDEP_HAVE_LIBCAP$/ d' sysdeputil.c
		sed -i '/libcap/ d' vsf_findlibs.sh
	fi

	# Let portage control stripping
	sed -i '/^LINK[[:space:]]*=[[:space:]]*/ s/-Wl,-s//' Makefile
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die
}

src_install() {
	into /usr
	doman vsftpd.conf.5 vsftpd.8
	dosbin vsftpd || die

	dodoc AUDIT BENCHMARKS BUGS Changelog FAQ \
		README README.security REWARD SIZE \
		SPEED TODO TUNING
	newdoc vsftpd.conf vsftpd.conf.example

	docinto security
	dodoc SECURITY/*

	insinto "/usr/share/doc/${PF}/examples"
	doins -r EXAMPLE/*

	insinto /etc/vsftpd
	newins vsftpd.conf vsftpd.conf.example

	insinto /etc/logrotate.d
	newins "${FILESDIR}/vsftpd.logrotate" vsftpd

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/vsftpd.xinetd" vsftpd
	fi

	newinitd "${FILESDIR}/vsftpd.init" vsftpd

	keepdir /usr/share/vsftpd/empty
}

pkg_preinst() {
	# If we use xinetd, then we comment out listen=YES
	# so that our default config works under xinetd - fixes #78347
	if use xinetd ; then
		sed -i '/\listen=YES/s/^/#/g' "${D}"/etc/vsftpd/vsftpd.conf.example
	fi
}

pkg_postinst() {
	einfo "vsftpd init script can now be multiplexed."
	einfo "The default init script forces /etc/vsftpd/vsftpd.conf to exist."
	einfo "If you symlink the init script to another one, say vsftpd.foo"
	einfo "then that uses /etc/vsftpd/foo.conf instead."
	einfo
	einfo "Example:"
	einfo "   cd /etc/init.d"
	einfo "   ln -s vsftpd vsftpd.foo"
	einfo "You can now treat vsftpd.foo like any other service"
}
