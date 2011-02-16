# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils versionator

MY_P=${PN}$(replace_version_separator 1 '')

DESCRIPTION="Freely distributable math library"
HOMEPAGE="http://www.validlab.com/software/"
SRC_URI="http://www.validlab.com/software/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${MY_P}

DEPEND="sys-devel/libtool"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}
