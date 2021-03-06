# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit eutils

IUSE=""

DESCRIPTION="A milter for SpamAssassin"
HOMEPAGE="http://savannah.nongnu.org/projects/spamass-milt/"
SRC_URI="http://savannah.nongnu.org/download/spamass-milt/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

DEPEND=">=sys-devel/autoconf-2.57
	>=sys-devel/automake-1.7.2"
RDEPEND="mail-filter/libmilter
	>=mail-filter/spamassassin-3.1.0"

pkg_setup() {
	enewgroup milter
	enewuser milter -1 -1 /var/milter milter
}

src_install() {
	make DESTDIR=${D} install || die

	newinitd ${FILESDIR}/spamass-milter.rc3 spamass-milter
	newconfd ${FILESDIR}/spamass-milter.conf3 spamass-milter
	dodir /var/run/milter
	keepdir /var/run/milter
	fowners milter:milter /var/run/milter
	dodir /var/milter
	keepdir /var/milter
	fowners milter:milter /var/milter

	dodoc AUTHORS NEWS README ChangeLog ${FILESDIR}/README.gentoo
}

pkg_postinst() {
	elog
	elog "Documentation is in /usr/share/doc/${P}"
	elog "Check README.gentoo.gz there for some basic gentoo installation instructions"
	elog
}
