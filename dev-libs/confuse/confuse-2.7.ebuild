# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/confuse/confuse-2.6-r3.ebuild,v 1.6 2008/12/17 22:09:10 maekke Exp $

EAPI="2"

DESCRIPTION="a configuration file parser library"
HOMEPAGE="http://www.nongnu.org/confuse/"
SRC_URI="mirror://nongnu/confuse/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="nls"

DEPEND="sys-devel/flex
	dev-util/pkgconfig
	sys-devel/gettext
	nls? ( sys-devel/gettext )"
RDEPEND="nls? ( virtual/libintl )"

src_configure() {
	# examples are normally compiled but not installed. They
	# fail during a mingw crosscompile.
	econf $(use_enable nls) \
		--enable-shared \
		--disable-examples
}

src_install() {
	emake DESTDIR="${D}" install || die

	doman doc/man/man3/*.3 || die
	dodoc AUTHORS NEWS README || die
	dohtml doc/html/* || die

	insinto /usr/share/doc/${PF}
	doins examples/*.c || die
}
