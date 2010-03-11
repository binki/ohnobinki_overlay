# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/supertux/supertux-0.1.3.ebuild,v 1.14 2009/02/23 01:02:56 mr_bones_ Exp $

EAPI=2

inherit cmake-utils eutils games subversion

DESCRIPTION="A game similar to Super Mario Bros."
HOMEPAGE="http://super-tux.sourceforge.net"
SRC_URI="ftp://ohnopub.net/mirror/supertux-r6591-crazy-system-findlocale-notinygettext.patch"

ESVN_REPO_URI="http://supertux.lethargik.org/svn/supertux/trunk/supertux"
ESVN_PROJECT="${PN}"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS=""
IUSE="opengl curl debug"

RDEPEND="dev-games/physfs
	dev-libs/findlocale
	dev-libs/tinygettext
	media-libs/libsdl[joystick]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl-image[png,jpeg]
	opengl? ( media-libs/glew
		virtual/opengl )
	curl? ( net-misc/curl )"

# supertux's CMakeLists.txt needs the svnversion command
# boost templates are used
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-util/cmake"

src_prepare() {
	epatch "${FILESDIR}/supertux-9999-tinygettext-external.patch"
	epatch "${DISTDIR}/supertux-r6591-crazy-system-findlocale-notinygettext.patch"

	rm -rf externals/{findlocale,tinygettext} || die
}

src_configure() {
	local mycmakeargs=( -DWERROR=OFF
			 -DINSTALL_SUBDIR_SHARE=share/games/supertux2
			 -DINSTALL_SUBDIR_BIN=games/bin
			 -DINSTALL_SUBDIR_DOC=share/doc/${P}
			 $(cmake-utils_use_enable opengl OPENGL)
			 $(cmake-utils_use_enable debug SQDBG)
			 $(cmake-utils_use debug DEBUG) )

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc README TODO WHATSNEW.txt data/credits.txt
	prepgamesdirs
}
