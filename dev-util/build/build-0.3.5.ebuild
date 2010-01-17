# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="A massively-parallel software build system implemented on top of GNU make"
HOMEPAGE="http://kolpackov.net/projects/build/"
SRC_URI="ftp://kolpackov.net/pub/projects/${PN}/${PV%.?}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples"

src_prepare() {
	if use examples; then
		# fix examples to use installed build
		sed -i -e "s;^include.\*bootstrap.make\$;include build-${PV%.?}/bootstrap.make;" \
			examples/*/*/{*/,}build/bootstrap.make || die "patching examples failed"
		rm examples/cxx/hello/hello/build/import/libhello || die "preparing examples for installation failed"
	fi
	if use doc; then
		# separate HTML and text docs
		mkdir html || die "preparing docs failed"
		mv documentation/*.{css,xhtml} html/ || die "preparing docs failed"
	fi
}

src_install() {
	emake install_prefix="${D}/usr" install || die "emake install failed"

	dodoc NEWS README || die "dodoc failed"

	if use doc; then
		dohtml -A xhtml html/* || die "installing HTML docs failed"
		dodoc documentation/* || die "installing plaintext docs failed"
	fi

	if use examples; then
		local docdir=/usr/share/doc/${PF}
		insinto ${docdir}

		# preserve symlinks and avoid cp:
		doins -r examples || die "installing examples failed"
		dosym ../../../libhello/build/import/libhello ${docdir}/examples/cxx/hello/hello/build/import/libhello || die "repairing examples symlink failed"
	fi
}
