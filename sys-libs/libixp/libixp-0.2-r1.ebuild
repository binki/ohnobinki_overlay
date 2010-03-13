# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libixp/libixp-0.2-r1.ebuild,v 1.7 2007/11/19 03:59:15 omp Exp $

EAPI="2"

inherit base eutils multilib toolchain-funcs

DESCRIPTION="Standalone client/server 9P library"
HOMEPAGE="http://libs.suckless.org/"
SRC_URI="http://libs.suckless.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND="!>=sys-libs/libixp-0.4"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/libixp-0.2-shared-object.patch"

	sed -i \
		-e "/^PREFIX/s|=.*|= /usr|" \
		-e "/^CFLAGS/s|= -Os|+=|" \
		-e "/^LDFLAGS/s|=|+=|" \
		-e "/^AR/s|=.*|= $(tc-getAR) cr|" \
		-e "/^CC/s|=.*|= $(tc-getCC)|" \
		-e "/^RANLIB/s|=.*|= $(tc-getRANLIB)|" \
		-e "/^LIBS/iLIBDIR = \$(PREFIX)/$(get_libdir)" \
		-e "/^LIBS =/s|-L/usr/lib|-L\$(LIBDIR)|" \
		config.mk || die "sed failed"

	sed -i \
		-e 's|${PREFIX}/lib|${LIBDIR}|g' \
		Makefile || die "sed failed"
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
}
