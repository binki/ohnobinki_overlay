# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools base

DESCRIPTION="Implements the client-side of the Internet Relah Chat protocol"
HOMEPAGE="http://libircclient.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples ipv6 threads"

DEPEND=""
RDEPEND=""

src_prepare() {
	rm configure.in || die
	epatch "${FILESDIR}"/${P}-autotools.patch

	eautoreconf
}

src_configure() {
	econf --disable-debug \
		$(use_enable ipv6) \
		$(use_enable threads) \
		$(use_enable examples)
}
