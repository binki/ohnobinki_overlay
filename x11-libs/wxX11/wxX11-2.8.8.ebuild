#derived of:
# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/wxGTK/wxGTK-2.8.8.0.ebuild,v 1.1 2008/06/29 05:22:00 dirtyepic Exp $



inherit eutils

DESCRIPTION="X11 version of the wxWidgets, a cross-platform C++ GUI toolkit."

SRC_URI="mirror://sourceforge/wxwindows/${P}.tar.bz2"

KEYWORDS="amd64"

SLOT="0"
LICENSE="wxWinLL-3
		GPL-2"

RDEPEND="
jpeg? ( media-libs/jpeg )
png? ( media-libs/png )
tiff? ( media-libs/tiff )
xpm? ( x11-libs/Xpm )
sdl? media-libs/libsdl
gnome? (
		gnome-base/libgnomeprint
		)
zlib? sys-libs/zlib
odbc?   ( dev-db/unixODBC )
expat? ( dev-libs/expat )
gstreamer? ( media-libs/gstreamer )"
DEPEND="${RDEPEND}
		dev-util/pkgconfig
		x11-proto/xproto
		x11-proto/xineramaproto
		x11-proto/xf86vidmodeproto"

src_unpack()
{
	unpack ${A}
}

src_compile()
{
	mkdir "${S}"/wxx11_build
	cd "${S}"/wxx11_build

	ECONF_SOURCE="${S}" econf || die "configure failed."

	emake || die "make failed."
}

src_install()
{
	cd "${S}"/wxx11_build

	emake DESTDIR="${D}" install || die "install failed."
}

pkg_postrm() {
	has_version app-admin/eselect-wxwidgets \
		&& eselect wxwidgets update
}
