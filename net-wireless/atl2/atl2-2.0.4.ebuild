# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

DESCRIPTION="Attansic/Atheros L2 Fast Ethernet adapter."
HOMEPAGE="http://atl2.sf.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
SRC_URI="http://people.redhat.com/csnook/${PN}/${P}.tar.bz2"
RESTRICT="mirror"
LICENSE="GPL2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

MODULE_NAMES="atl2(atl2:${S}:${S})"
BUILD_TARGETS="all"
