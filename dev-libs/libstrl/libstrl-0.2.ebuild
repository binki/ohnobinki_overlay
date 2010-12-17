# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/apr-util/apr-util-1.3.9.ebuild,v 1.12 2009/11/04 12:12:05 arfrever Exp $

EAPI="2"

inherit base multilib

DESCRIPTION="Compat library for functions like strlcpy(), strlcat(), and strnlen()"
HOMEPAGE="http://ohnopub.net/~ohnobinki/libstrl/"
SRC_URI="ftp://mirror.calvin.edu/~binki/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86"
IUSE="doc test"

DEPEND="doc? ( app-doc/doxygen )
	test? ( dev-libs/check )"
RDEPEND=""

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_with doc doxygen) \
		$(use_with test check)
}

src_install() {
	base_src_install

	rm -vf "${D}"/usr/$(get_libdir)/libstrl.la || die
}
