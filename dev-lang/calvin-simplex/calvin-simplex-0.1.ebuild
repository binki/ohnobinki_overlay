# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

DESCRIPTION="Implementation of a virtual machine and assembler for Simplex, an oversimplified educational tool"
HOMEPAGE="http://ohnopub.net/~ohnobinki/calvin-simplex.php"
SRC_URI="ftp://ohnopub.net/mirror/${P}.tar.bz2
	http://protofusion.org/mirror/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-libs/liblist"
DEPEND="${RDEPEND}
	sys-devel/flex
	doc? ( app-text/txt2man )"

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
	)

	autotools-utils_src_configure
}
