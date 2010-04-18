# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="LEAP MS-CHAPv2 cracking tool for ancient Cisco WiFi setups"
HOMEPAGE="http://willhackforsushi.com/Asleap.html"
SRC_URI="http://www.willhackforsushi.com/code/${PN}/${PV}/${P}.tgz"
LICENSE=GPL-2

SLOT=0
KEYWORDS="~amd64"
IUSE=

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS}" || die
}

src_instal() {
	dobin ${PN} genkeys || die
	dodoc THANKS README || die
}
