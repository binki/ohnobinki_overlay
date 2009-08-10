# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit php-lib-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP OpenID Implementation"
HOMEPAGE="http://openidenabled.com/php-openid/"
SRC_URI="http://openidenabled.com/files/php-openid/packages/php-openid-${PV}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
PHP_LIB_NAME="Auth"

MY_PN=php-openid
MY_S=${WORKDIR}/${MY_PN}-${PV}

RDEPEND="|| ( virtual/php[bcmath] virtual/php[gmp] )
virtual/php[curl]"

src_install()
{
	cd "${MY_S}"/Auth

	php-lib-r1_src_install . * */*
}
