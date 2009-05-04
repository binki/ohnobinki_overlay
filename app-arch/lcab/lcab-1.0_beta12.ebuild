# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit autotools

MY_PV="${PV/_beta/b}"

DESCRIPTION="CAB file creation tool"
HOMEPAGE="http://lcab.move-to-cork.com"
SRC_URI="mirror://ohnoproto/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/libc"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i "s:1.0b11:${MY_PV}:" mytypes.h
	eautoreconf || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README
}
