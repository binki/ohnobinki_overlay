# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/liblist/liblist-2.1-r1.ebuild,v 1.1 2009/12/05 22:32:30 nerdboy Exp $

EAPI="2"

inherit autotools mercurial

DESCRIPTION="This package provides generic linked-list manipulation routines, plus queues and stacks."
HOMEPAGE="http://ohnopub.net/hg/liblist-unbased"
SRC_URI=""
EHG_REPO_URI="http://ohnopub.net/hg/liblist-unbased"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

S=${WORKDIR}/${PN}-unbased

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_enable doc docs) \
		$(use_enable examples)
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc README || die

	if use examples; then
		insinto /usr/share/doc/${P}/examples
		doins examples/{*.c,Makefile,README} || die
		insinto /usr/share/doc/${P}/examples/cache
		doins examples/cache/{*.c,Makefile,README} || die
	fi
}

pkg_postinst() {
	elog "Note the man pages for this package have been renamed to avoid"
	elog "name collisions with some system functions, however, the libs"
	elog "and header files have not been changed."
	elog "The new names are llist, lcache, lqueue, and lstack."
}