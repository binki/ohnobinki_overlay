# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/liblist/liblist-2.1-r1.ebuild,v 1.1 2009/12/05 22:32:30 nerdboy Exp $

EAPI="2"

inherit eutils mercurial toolchain-funcs

DESCRIPTION="This package provides generic linked-list manipulation routines, plus queues and stacks."
HOMEPAGE="http://ohnopub.net/hg/liblist/-unbased"
SRC_URI=""
EHG_REPO_URI="http://ohnopub.net/hg/liblist-unbased"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

S=${WORKDIR}/${PN}-unbased

src_prepare() {
	epatch "${FILESDIR}"/${P}-sharedlib.patch
	sed -i -e "s:/usr/lib:/usr/$(get_libdir):g" Makefile \
		examples/cache/Makefile || die "sed 1 failed"
}

src_compile() {
	make CC="$(tc-getCC)" LD="$(tc-getCC)" \
		|| die "make failed"
}

src_install() {
	newman list.3 llist.3 || die
	newman stack.3 lstack.3 || die
	newman queue.3 lqueue.3 || die
	dolib.a ${PN}.a || die
	dolib.so ${PN}.so* || die
	insinto /usr/include
	doins list.h queue.h stack.h || die
	dodoc README || die

	if use examples; then
		dolib.a examples/cache/libcache.a || die
		dobin examples/cache/cachetest || die
		newman examples/cache/cache.3 lcache.3 || die
		insinto /usr/share/doc/${P}/examples
		doins examples/{*.c,Makefile,README} || die
		insinto /usr/share/doc/${P}/examples/cache
		doins examples/cache/{*.c,Makefile,README} || die
	fi

	if use doc; then
		insinto /usr/share/doc/${P}
		doins paper/paper.ps || die
	fi
}

pkg_postinst() {
	elog "Note the man pages for this package have been renamed to avoid"
	elog "name collisions with some system functions, however, the libs"
	elog "and header files have not been changed."
	elog "The new names are llist, lcache, lqueue, and lstack."
}
