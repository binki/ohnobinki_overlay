# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Date/PEAR-Date-1.4.6.ebuild,v 1.16 2008/01/10 10:06:27 vapier Exp $

EAPI="2"

inherit php-pear-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Yadis implementation, primarily for OpenID."
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="dev-php/PEAR-Net_URL2
	dev-php/PEAR-Validate"
