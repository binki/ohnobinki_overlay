# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://github.com/dapphp/securimage https://dapphp/securimage"

inherit git-2

DESCRIPTION="PHP captcha creator and validator library"
HOMEPAGE="http://phpcaptcha.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

src_install()
{
	insinto /usr/share/php/${PN}
	doins -r *.{ttf,php,swf} audio backgrounds database gdfonts images words

	dodoc README*
}
