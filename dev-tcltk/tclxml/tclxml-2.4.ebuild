# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tclxml/tclxml-2.4.ebuild,v 1.18 2007/12/28 17:22:03 mr_bones_ Exp $

inherit multilib

DESCRIPTION="Pure Tcl implementation of an XML parser."
HOMEPAGE="http://tclxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/tclxml/${P}.tar.gz"
IUSE=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 alpha sparc ~amd64"
DEPEND=">=dev-lang/tcl-8.3.3"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i -e "s/relid'/relid/" \
		configure tcl.m4 tclconfig/tcl.m4 expat/configure || die
}

src_compile() {
	econf --with-tcl=/usr/$(get_libdir) || die
	make || die

	# Need to hack the config script.
	sed -i 's:NONE:/usr:' TclxmlConfig.sh
}

src_install() {
	einstall || die
	dodoc ChangeLog LICENSE README RELNOTES
}
