# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools-utils multilib

DESCRIPTION="Compat library for functions like strlcpy(), strlcat(), and strnlen()"
HOMEPAGE="http://ohnopub.net/~ohnobinki/libstrl/"
SRC_URI="ftp://mirror.calvin.edu/~binki/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86"
IUSE="doc static-libs test"

DEPEND="doc? ( app-doc/doxygen )
	test? ( dev-libs/check )"
RDEPEND=""

src_configure() {
	myeconfargs=(
		$(use_with doc doxygen)
		$(use_with test check)
	)

	autotools-utils_src_configure
}
