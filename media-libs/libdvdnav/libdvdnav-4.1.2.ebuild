# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="2.5"


inherit eutils autotools multilib base

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="http://mplayerhq.hu/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="debug"
SRC_URI="http://www3.mplayerhq.hu/MPlayer/releases/dvdnav/libdvdnav-4.1.2.tar.gz"

PROVIDE="media-libs/libdvdread"

RDEPEND=">=media-libs/libdvdread-0.9.7"
DEPEND=">=media-libs/libdvdread-0.9.7"

src_unpack() {
	base_src_unpack
	cd "${S}"
	#remove it so that it can't be found and so that we get the errors we WANT :-) (like, "can't find nav_types.h" which should be in /usr/include/dvdread and is also in src/dvdread (which may have incompatible headers))
	mv src/dvdread src/notdvdread

	epatch "${FILESDIR}/${P}-nomake_libdvdread.diff"
	epatch "${FILESDIR}/${P}-mydebug.diff"

	eautoreconf
}

src_compile() {

	#there is probably a MUCH better fix than the following line, but I've heard rumors of dissent concerning configure scripts, so I won't waste my time in m4 :-)
	LDFLAGS="${LDFLAGS} -L/usr/$(get_libdir)/dvdread -ldvdread"
	./configure --prefix=/usr --libdir=/usr/$(get_libdir) \
		--enable-static --enable-shared \
		--disable-strip --disable-opts \
		$(use_enable debug) || die "configure died"

	emake || die "emake died"
}

src_install () {
	emake -j1 DESTDIR="${D}" install || die "emake install died"
	dodoc AUTHORS DEVELOPMENT-POLICY.txt ChangeLog TODO \
		doc/dvd_structures
}
