# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base

DESCRIPTION="Script for committing to the sunrise overlay and other Gentoo repositories"
HOMEPAGE="https://github.com/mgorny/sunrise-commit/"
SRC_URI="http://cloud.github.com/downloads/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE=""

RDEPEND="!!app-portage/overlay-utils
	>=app-portage/gentoolkit-dev-0.2.7
	sys-apps/portage"
