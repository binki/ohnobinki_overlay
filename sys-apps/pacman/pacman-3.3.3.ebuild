# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools

DESCRIPTION="archlinux's binary package manager"
HOMEPAGE="http://archlinux.org/pacman/"
SRC_URI="ftp://ftp.archlinux.org/other/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug doc +internal-download test"

RDEPEND="app-arch/libarchive
	virtual/libiconv
	virtual/libintl
	internal-download? ( dev-libs/http-fetcher )
	sys-devel/gettext"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-lang/python )"

src_prepare() {
	sed -i -e 's/-Werror//g' configure.ac || die "-Werror"
	# acinclude.m4 overrides libtool macros from /usr/share/aclocal, causing
	# elibtoolize's ltmain.sh to incompatible with ./configure after
	# eautoreconf is run.
	sed -i -e 4,4873d acinclude.m4 || die "libtool fix"
	eautoreconf
}

src_configure() {
	econf --disable-git-version \
		$(use_enable debug) \
		$(use_enable doc) \
		$(use_enable doc doxygen) \
		$(use_enable internal-download)
}

src_install() {
	emake DESTDIR="${D}" install || die
}
