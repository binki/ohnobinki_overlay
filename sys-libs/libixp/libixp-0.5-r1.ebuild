# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libixp/libixp-0.5.ebuild,v 1.1 2009/07/11 11:12:37 omp Exp $

EAPI=2

inherit multilib

DESCRIPTION="Standalone client/server 9P library"
HOMEPAGE="http://libs.suckless.org/libixp"
SRC_URI="http://code.suckless.org/dl/libs/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	sed -i \
		-e "/^PREFIX/s|=.*|= ${D}/usr|" \
		-e "/^  ETC/s|=.*|= ${D}/etc|" \
		-e "/^CFLAGS/s|=|+=|" \
		-e "/^LDFLAGS/s|=|+=|" \
		-e "/LIBDIR =/s|/lib|/$(get_libdir)|" \
		config.mk || die "sed failed"
}

src_compile() {
	emake -j1 || die
}

src_install() {
	emake -j1 DESTDIR="${D}" install
}
