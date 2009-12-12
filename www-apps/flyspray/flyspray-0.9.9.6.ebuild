# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

# we need webapp's default pkg_setup()
inherit webapp

DESCRIPTION="An uncomplicated web-based bug tracking system"
HOMEPAGE="http://flyspray.org/"
SRC_URI="http://flyspray.org/${P}.zip"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64"
IUSE="graphviz"

COMMON_DEPEND="virtual/httpd-php[xml]
	|| ( virtual/httpd-php[mysql]
		virtual/httpd-php[mysqli]
		virtual/httpd-php[postgres] )"
DEPEND="app-arch/unzip
	${COMMON_DEPEND}"
RDEPEND="graphviz? ( media-gfx/graphviz )
	${COMMON_DEPEND}"

src_prepare () {
	mv htaccess.dist .htaccess || die
}

src_install () {
	webapp_src_preinst

	dodoc docs/*.txt || die
	rm -r docs || die

	insinto "${MY_HTDOCSDIR}"
	doins -r . || die

	webapp_serverowned "${MY_HTDOCSDIR}"/{attachments,cache}
	webapp_configfile "${MY_HTDOCSDIR}"/.htaccess

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
