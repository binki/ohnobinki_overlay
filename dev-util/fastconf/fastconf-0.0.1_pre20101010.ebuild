# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base

DESCRIPTION="A speedy and POSIX-sh compatible replacement for autoconf and most of automake"
HOMEPAGE="http://github.com/mgorny/fastconf/"
SRC_URI="ftp://ohnopub.net/mirror/${P}.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE=""

S=${WORKDIR}/${PN}
