# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/confuse/confuse-2.6-r3.ebuild,v 1.6 2008/12/17 22:09:10 maekke Exp $

inherit eutils autotools

DESCRIPTION="a configuration file parser library"
HOMEPAGE="http://www.nongnu.org/confuse/"
SRC_URI="http://bzero.se/confuse/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="nls"

DEPEND="sys-devel/flex
	sys-devel/libtool
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"
RDEPEND="nls? ( virtual/libintl )"

pkg_setup() {
	ewarn "This copy of confuse has a patch that causes cfg_include"
	ewarn "to include files relative to the file calling cfg_include."
	ewarn "This may break packages designed for vanilla confuse. Please"
	ewarn "bug me at https://ohnopublishing.net/bugs/ if you have problems"
	ewarn "with this."
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# bug #236347
	epatch "${FILESDIR}"/${P}-O0.patch
	# bug 239020
	epatch "${FILESDIR}"/${P}-solaris.patch
	# don't compile examples:
	epatch "${FILESDIR}"/${P}-noexamples.patch

	#relative cfg_include()s
	epatch "${FILESDIR}"/${P}-relativeincludes.patch
	#force regeneration of lexer.c
	rm src/lexer.c

	# drop -Werror, bug #208095 (in confuse-2.7)
	sed -i -e 's/-Werror//' */Makefile.* || die

	eautoreconf
}

src_compile() {
	econf --enable-shared --disable-examples || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	doman doc/man/man3/*.3
	dodoc AUTHORS NEWS README
	dodoc examples/*.c examples/*.conf
	dohtml doc/html/* || die
}
