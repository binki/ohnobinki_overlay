# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

GITHUB_USER=tpyo
GIT_COMMIT=390ea1a454456d27784fa01264d34ed13c57a95a

DESCRIPTION="PHP wrapper around Amazon S3 API"
HOMEPAGE="http://undesigned.org.za/2007/10/22/amazon-s3-php-class https://github.com/tpyo/amazon-s3-php-class"
SRC_URI="https://github.com/${GITHUB_USER}/amazon-s3-php-class/tarball/${GIT_COMMIT} -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/php:*[curl,ssl]"

S="${WORKDIR}/${GITHUB_USER}-${PN}-${GIT_COMMIT:0:7}"

src_install() {
	insinto /usr/share/php
	doins S3.php

	dodoc README.txt

	docinto examples
	dodoc example*.php
	docompress -x /usr/share/doc/${PF}/examples
}
