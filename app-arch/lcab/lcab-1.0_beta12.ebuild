# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="2"

inherit autotools

MY_PV="${PV/_beta/b}"

DESCRIPTION="CAB file creation tool"
HOMEPAGE="http://ohnopublishing.net/lcab/"
SRC_URI="ftp://ohnopublishing.net/mirror/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	sed -i "s:1.0b11:${MY_PV}:" mytypes.h
	eautoreconf || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README || die "dodoc"
}
