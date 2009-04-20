# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/supertux/supertux-0.1.3.ebuild,v 1.14 2009/02/23 01:02:56 mr_bones_ Exp $

EAPI=2
inherit subversion cmake-utils eutils games

DESCRIPTION="A game similar to Super Mario Bros."
HOMEPAGE="http://super-tux.sourceforge.net"
SRC_URI=""

ESVN_REPO_URI="http://supertux.lethargik.org/svn/supertux/trunk/supertux"
ESVN_PROJECT="${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug opengl curl"

RDEPEND="media-libs/libsdl[joystick]
	media-libs/sdl-image[png,jpeg]
	media-libs/libvorbis
	dev-games/physfs
	media-libs/openal
	x11-libs/libXt
	opengl? ( virtual/opengl )
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-util/subversion"

src_unpack() {
	subversion_src_unpack
}

src_configure() {
	local mycmakeargs="$(cmake-utils_use_enable opengl OPENGL)
			 -DWERROR=OFF
			 $(cmake-utils_use_enable debug SQDBG)
			 $(cmake-utils_use debug DEBUG)"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog LEVELDESIGN README TODO WHATSNEW.txt data/credits.txt
	prepgamesdirs
}
