# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="2.5"


inherit eutils autotools multilib subversion

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="http://mplayerhq.hu/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="debug"

ESVN_REPO_URI="svn://svn.mplayerhq.hu/dvdnav/trunk/libdvdnav"
ESVN_PROJECT="libdvdnav"

PROVIDE="media-libs/libdvdread"

src_compile() {
	./configure2 --prefix=/usr --libdir=/usr/$(get_libdir) \
		--shlibdir=/usr/$(get_libdir) --enable-static --enable-shared \
		--disable-strip --disable-opts \
		--extra-cflags=${CFLAGS} $(use_enable debug) || die "configure2 died"
	emake version.h && emake || die "emake version.h died"
	emake || die "emake died"
}

src_install () {
	emake -j1 DESTDIR="${D}" install || die "emake install died"
	dodoc AUTHORS DEVELOPMENT-POLICY.txt ChangeLog TODO \
		doc/dvd_structures
}
