# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook2X/docbook2X-0.8.8-r2.ebuild,v 1.15 2010/07/18 16:46:46 armin76 Exp $

EAPI=2

# bug 318297
WANT_AUTOMAKE="1.10"

inherit autotools eutils

DESCRIPTION="Tools to convert docbook to man and info"
SRC_URI="mirror://sourceforge/docbook2x/${P}.tar.gz"
HOMEPAGE="http://docbook2x.sourceforge.net/"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="test"
LICENSE="MIT"

# dev-perl/XML-LibXML - although not mentioned upstream is required
# for make check to complete.
RDEPEND="dev-lang/perl
	dev-libs/libxslt
	dev-perl/XML-NamespaceSupport
	dev-perl/XML-SAX
	dev-perl/XML-LibXML
	app-text/docbook-xsl-stylesheets
	=app-text/docbook-xml-dtd-4.2*"
DEPEND="test? ( ${RDEPEND} )"

src_prepare() {
	# Patches from debian, for description see patches itself.
	epatch "${FILESDIR}"/${P}-filename_whitespace_handling.patch
	epatch "${FILESDIR}"/${P}-preprocessor_declaration_syntax.patch
	epatch "${FILESDIR}"/${P}-error_on_missing_refentry.patch

	eautoreconf #290284
}

src_configure() {
	econf \
		--with-xslt-processor=libxslt \
		--program-transform-name='s,\(docbook2.*\),\1.pl,'
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO || die
}

pkg_postinst() {
	elog "To avoid conflict with docbook-sgml-utils, which is much more widely used,"
	elog "all executables have been renamed to *.pl."
}
