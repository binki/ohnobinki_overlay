# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils mono multilib

DESCRIPTION="Level editor for supertux milestone 2"
HOMEPAGE="http://supertux.lethargik.org/wiki/Editor_FAQ"
SRC_URI="ftp://ohnopub.net/mirror/${P}.tar.bz2
	http://protofusion.org/mirror/${P}.tar.bz2"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/mono
	dev-dotnet/glade-sharp:2
	dev-dotnet/gtk-sharp:2"
RDEPEND="${DEPEND}
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
