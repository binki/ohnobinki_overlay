# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PHP_LIB_NAME=S3

inherit depend.php php-lib-r1

GITHUB_USER=tpyo
GIT_COMMIT=390ea1a454456d27784fa01264d34ed13c57a95a

DESCRIPTION="PHP wrapper around Amazon S3 API"
HOMEPAGE="http://undesigned.org.za/2007/10/22/amazon-s3-php-class https://github.com/tpyo/amazon-s3-php-class"
SRC_URI="https://github.com/${GITHUB_USER}/amazon-s3-php-class/tarball/${GIT_COMMIT} -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${GITHUB_USER}-${PN}-${GIT_COMMIT:0:7}"

pkg_setup() {
	# based on curl, calls openssl_pkey_get_private()
	require_php_with_use curl ssl
}

src_install() {
	# based on php-lib-r1_src_install()
	has_php

	if [[ -n "${PHP_SHARED_CAT}" ]]; then
		PHP_LIB_DIR=/usr/share/"${PHP_SHARED_CAT}"
	else
		PHP_LIB_DIR=/usr/share/php
	fi

	insinto "${PHP_LIB_DIR}"
	doins ${PHP_LIB_NAME}.php

	dodoc README.txt

	docinto examples
	dodoc example*.php
	docompress -x /usr/share/doc/${PF}/examples
}
