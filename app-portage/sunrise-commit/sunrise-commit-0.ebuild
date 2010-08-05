# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Script for committing to the sunrise overlay"
HOMEPAGE="http://git.qwpx.net/~mgorny/sunrise-commit/"
SRC_URI="ftp://ohnopub.net/mirror/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="!!app-portage/overlay-utils
	sys-apps/portage"

S=${WORKDIR}/${PN}

src_install() {
	dobin ${PN} || die

	doman ${PN}.1 || die
}
