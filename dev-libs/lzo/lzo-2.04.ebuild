# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/lzo/lzo-2.04.ebuild,v 1.6 2011/03/22 20:41:40 ranger Exp $

EAPI=2

WANT_AUTOCONF=2.5

inherit autotools eutils

DESCRIPTION="An extremely fast compression and decompression library"
HOMEPAGE="http://www.oberhumer.com/opensource/lzo/"
SRC_URI="http://www.oberhumer.com/opensource/lzo/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="examples static-libs"

RDEPEND=""
DEPEND=">=sys-devel/autoconf-2.67"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asm-makefile.patch

	# lzo has some weird sort of mfx_* set of autoconf macros which may
	# only be distributed with lzo itself? Rescue them and place them
	# into acinclude.m4 because there doesn't seem to be an m4/...
	sed -n -e '/^AC_DEFUN.*mfx_/,/^])#$/p' aclocal.m4 > acinclude.m4 || die "Unable to rescue mfx_* autoconf macros."
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS doc/*

	if use examples; then
		docinto examples
		dodoc examples/*.{c,h}
	fi

	find "${D}" -name '*.la' -exec rm -f '{}' +
}
