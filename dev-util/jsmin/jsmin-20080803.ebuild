# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="A JavaScript minifier"
HOMEPAGE="http://crockford.com/javascript/jsmin.html"
SRC_URI="mirror://ohnoproto/${P}.c"
LICENSE="as-is"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}

src_compile() {
		$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -o ${PN} "${DISTDIR}"/${P}.c || die
}

src_install() {
		doexe ${PN} || die
}
