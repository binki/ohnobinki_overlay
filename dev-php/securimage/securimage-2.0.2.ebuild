# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="PHP captcha creator and validator library"
HOMEPAGE="http://phpcaptcha.org/"
# Upstream doesn't version the tarball, so I do. --binki
SRC_URI="ftp://ohnopub.net/mirror/${P}.tar.gz
	http://protofusion.org/mirror/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}

src_prepare() {
	# It's good that the license is distributed, we just don't want to
	# install it below.
	rm -v LICENSE.txt || die
}

src_install()
{
	insinto /usr/share/php/${PN}
	doins -r *.{ttf,php,swf} audio backgrounds database gdfonts images words || die

	dodoc README* || die
}
