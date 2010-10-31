# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base versionator

DESCRIPTION="Script for committing to the sunrise overlay and other Gentoo repositories"
HOMEPAGE="http://github.com/mgorny/sunrise-commit/"
SRC_URI="ftp://ohnopub.net/mirror/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE=""

RDEPEND="!!app-portage/overlay-utils
	sys-apps/portage"

S=${WORKDIR}/${PN}-$(get_version_component_range 1-2)
