# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils mono multilib subversion

DESCRIPTION="Level editor for supertux milestone 2"
HOMEPAGE="http://supertux.lethargik.org/wiki/Editor_FAQ"
ESVN_REPO_URI="http://supertux.lethargik.org/svn/supertux/trunk/supertux-editor"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/mono
	dev-dotnet/glade-sharp:2
	dev-dotnet/gtk-sharp:2"
RDEPEND="${DEPEND}
	games-arcade/supertux:1
	=media-libs/libsdl-1.2*[opengl,X]
	media-libs/sdl-image[png]
	virtual/glu
	virtual/opengl"

src_install()
{
	insinto /usr/$(get_libdir)/${PN}
	doins *.{config,dll,exe} || die

	make_wrapper ${PN} "mono /usr/$(get_libdir)/${PN}/supertux-editor.exe"
}
