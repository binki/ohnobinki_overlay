# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Install /etc/portage/postsync.d/eix-update which is missing from app-portage/eix"
HOMEPAGE="http://dev.gentoo.org/~binki"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome X"

RDEPEND="app-portage/eix"

S=${WORKDIR}

src_install() {
	:
	exeinto /etc/portage/postsync.d
	doexe "${FILESDIR}/eix-update"
}
