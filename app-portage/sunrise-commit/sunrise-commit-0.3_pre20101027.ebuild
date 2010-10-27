# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base

DESCRIPTION="Script for committing to the sunrise overlay"
HOMEPAGE="http://github.com/mgorny/sunrise-commit/"
SRC_URI="ftp://ohnopub.net/mirror/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE=""

DEPEND="dev-util/fastconf"
RDEPEND="!!app-portage/overlay-utils
	sys-apps/portage"

S=${WORKDIR}/${PN}
