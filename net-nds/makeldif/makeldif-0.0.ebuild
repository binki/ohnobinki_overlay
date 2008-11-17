# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A utility to export your NSS databases in a potentially usable LDIF format"
HOMEPAGE="http://ohnopublishing.net/~ohnobinki/makeldif/"
SRC_URI="http://ohnopublishing.net/~ohnobinki/makeldif/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc COPYING || die
}
