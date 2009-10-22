# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tcldom/tcldom-2.6.ebuild,v 1.6 2006/06/04 02:34:19 matsuu Exp $

EAPI="2"

inherit multilib

DESCRIPTION="Document Object Model For Tcl"
HOMEPAGE="http://tclxml.sourceforge.net/tcldom.html"
SRC_URI="mirror://sourceforge/tclxml/${P}.tar.gz"
IUSE=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"

DEPEND=">=dev-lang/tcl-8.3.3"
RDEPEND="${DEPEND}
	>=dev-tcltk/tclxml-2.6"

src_prepare() {
	# bug 131148
	sed -i -e "s/relid'/relid/" \
		{,src-libxml2/}configure {config,tclconfig}/tcl.m4 || die
}

src_configure() {
	econf --with-tcl=/usr/$(get_libdir)
}

src_install() {
	einstall || die
	dodoc ChangeLog LICENSE README RELNOTES
}
