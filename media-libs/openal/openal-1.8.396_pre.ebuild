# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/openal/openal-1.7.411.ebuild,v 1.1 2009/04/08 20:11:46 hanno Exp $

inherit eutils cmake-utils git

MY_P=${PN}-soft-${PV}

DESCRIPTION="A software implementation of the OpenAL 3D audio API"
HOMEPAGE="http://kcat.strangesoft.net/openal.html"
SRC_URI=""

EGIT_REPO_URI="git://repo.or.cz/openal-soft.git"
EGIT_TREE="7a7a4844f441a2d269cffdadfd553655a8d3484e"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="alsa debug examples oss portaudio pulseaudio"
DEPEND="alsa? ( media-libs/alsa-lib )"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${MY_P}

DOCS="alsoftrc.sample"

src_compile() {
	local mycmakeargs="-DSOLARIS=OFF -DDSOUND=OFF -DWINMM=OFF"

	use alsa || mycmakeargs="${mycmakeargs} -DALSA=OFF"
	use oss || mycmakeargs="${mycmakeargs} -DOSS=OFF"
	use portaudio || mycmakeargs="${mycmakeargs} -DPORTAUDIO=OFF"
	use pulseaudio || mycmakeargs="${mycmakeargs} -DPULSEAUDIO=OFF"
	use examples || mycmakeargs="${mycmakeargs} -DEXAMPLES=OFF"
	use debug && mycmakeargs="${mycmakeargs} -DCMAKE_BUILD_TYPE=Debug"

	cmake-utils_src_compile
}

pkg_postinst() {
	einfo "If you have performance problems using this library, then"
	einfo "try add these lines to your ~/.alsoftrc config file:"
	einfo "[alsa]"
	einfo "mmap = off"
}
