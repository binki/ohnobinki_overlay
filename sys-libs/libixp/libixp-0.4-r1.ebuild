# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libixp/libixp-0.4.ebuild,v 1.1 2007/11/18 05:44:12 omp Exp $

EAPI=2

inherit multilib

DESCRIPTION="Standalone client/server 9P library"
HOMEPAGE="http://libs.suckless.org/"
SRC_URI="http://libs.suckless.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	sed -i \
		-e "/^PREFIX/s|=.*|= ${D}/usr|" \
		-e "/^ETC/s|=.*|= ${D}/etc|" \
		-e "/^CFLAGS/s|=|+=|" \
		-e "/^LDFLAGS/s|=|+=|" \
		-e "/LIBDIR =/s|/lib|/$(get_libdir)|" \
		-e "/^LIBS =/s|-L/usr/lib|-L\$(LIBDIR)|" \
		config.mk || die "sed failed"

	sed -i \
		-e '/^PTARG/s|${ROOT}/lib/||' \
		mk/lib.mk || die "sed failed"
	sed -i \
		-e '/^LIB/s|/lib/|/libixp/|' \
		cmd/Makefile || die "sed failed"
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
}
