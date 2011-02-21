# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/supertux/supertux-0.1.3.ebuild,v 1.14 2009/02/23 01:02:56 mr_bones_ Exp $

EAPI=2

inherit cmake-utils eutils games

DESCRIPTION="A platform game where Tux goes off in search of Penny... and isn't yet able to find her"
HOMEPAGE="http://supertux.lethargik.org/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2
	http://${PN}.googlecode.com/files/${P}.tar.bz2
	ftp://ohnopub.net/mirror/${PN}-r6591-crazy-system-findlocale-notinygettext.patch"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="opengl curl debug"

RDEPEND="dev-games/physfs
	dev-lang/squirrel
	dev-libs/findlocale
	dev-libs/tinygettext
	media-libs/libsdl[joystick]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl-image[png,jpeg]
	opengl? ( media-libs/glew
		virtual/opengl )
	curl? ( net-misc/curl )"

# boost templates are used
DEPEND="${RDEPEND}
	dev-libs/boost"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.3.3-externals.patch

	rm -rf externals/{findlocale,tinygettext,squirrel} || die
}

src_configure() {
	local mycmakeargs=( -DWERROR=OFF
			 -DINSTALL_SUBDIR_SHARE=share/games/supertux2
			 -DINSTALL_SUBDIR_BIN=games/bin
			 -DINSTALL_SUBDIR_DOC=share/doc/${P}
			 -DEXTERNAL_LIBSQUIRREL=YES
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
