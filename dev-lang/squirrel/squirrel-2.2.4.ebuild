# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${PN}_${PV}_stable"

DESCRIPTION="A interpreted language mainly used for games"
HOMEPAGE="http://squirrel-lang.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}${PV:0:1}/${MY_P}/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

# /usr/bin/sq conflicts
RDEPEND="!app-text/ispell"

S="${WORKDIR}/SQUIRREL${PV:0:1}"

src_compile() {
	if use amd64 ; then
		emake sq64 || die
	else
		emake || die
	fi
}

src_install() {
	dobin bin/sq || die
	dolib.a lib/*.a || die
	insinto /usr
	doins -r include || die
	dodoc HISTORY README || die

	if use doc ; then
		dodoc doc/*.pdf || die
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/samples
		doins -r etc samples/* || die
	fi
}
