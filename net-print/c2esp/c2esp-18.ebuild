# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit toolchain-funcs

MY_P=${PN}${PV}

DESCRIPTION="A cups filter for Kodak ESP printers"
HOMEPAGE="http://cupsdriverkodak.sf.net/"
SRC_URI="mirror://sourceforge/cupsdriverkodak/files/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

DEPEND=">=media-libs/jbigkit-2.0-r1
	>=net-print/cups-1.4"
RDEPEND="${DEPEND}"

src_prepare() {
	# Remove embedded media-libs/jbigkit
	rm -f *jbig* || die

	# Remove the embedded jbig files from the Makefile's dependencies:
	sed -i \
		-e '/^[a-z0-9.]*:/s/\$(LIBJBG)//g' \
		-e '/^[a-z0-9.]*:/s/jbig[^ ]*\.h//g' \
		Makefile || die

	# Use Gentoo-style cups paths
	sed -i -e s,/usr/lib/cups/filter,/usr/libexec/cups/filter,g ppd/*.ppd || die
}

src_compile() {
	emake CC="$(tc-getCC)" LIBJBG='-ljbig85 -ljbig'
}

src_install() {
	emake "${C2ESP_MAKE_OPTS[@]}" DESTDIR="${D}" FILTERBIN="${D}"/usr/libexec/cups/filter install
}
