# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/apr-util/apr-util-1.3.9.ebuild,v 1.12 2009/11/04 12:12:05 arfrever Exp $

EAPI="2"

DESCRIPTION="PHP captcha creator and validator library"
HOMEPAGE="http://phpcaptcha.org/"
SRC_URI="mirror://ohnoproto/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}

src_prepare() {
	# it's good that the license is distributed, we just don't want to
	# install it below.
	rm -v LICENSE.txt || die
}

src_install()
{
	insinto /usr/share/php/${PN}
	doins -r *.{ttf,php,swf} audio backgrounds database gdfonts images words || die

	dodoc README* || die
}
