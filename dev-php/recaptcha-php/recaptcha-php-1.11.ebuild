# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/apr-util/apr-util-1.3.9.ebuild,v 1.12 2009/11/04 12:12:05 arfrever Exp $

EAPI="2"

DESCRIPTION="PHP recaptcha client library"
HOMEPAGE="http://code.google.com/p/recaptcha/"
SRC_URI="http://recaptcha.googlecode.com/files/recaptcha-php-${PV}.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_install()
{
	insinto /usr/share/php
	doins recaptchalib.php || die

	insinto /usr/share/doc/${PF}/examples
	doins example-*.php || die

	dodoc README || die
}
