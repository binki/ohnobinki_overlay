# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-mesa/eselect-mesa-0.0.10.ebuild,v 1.10 2011/08/17 16:40:51 chithanh Exp $

EAPI=3

inherit eutils

DESCRIPTION="Utility to change the Mesa OpenGL driver being used"
HOMEPAGE="http://www.gentoo.org/"

SRC_URI="mirror://gentoo/${P}.tar.gz
	http://dev.gentoo.org/~binki/distfiles/${CATEGORY}/${PN}/${P}-multilib-binki.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris"
IUSE=""

DEPEND=""
RDEPEND=">=app-admin/eselect-1.2.4
	>=app-shells/bash-4"

src_prepare() {
	# Support multilib-nosymlink and arbitrary ABIs
	epatch "${DISTDIR}"/${P}-multilib-binki.patch
}

src_install() {
	insinto /usr/share/eselect/modules
	doins mesa.eselect || die
}

pkg_postinst() {
	if has_version ">=media-libs/mesa-7.9" && \
		! [ -f "${EROOT}"/usr/share/mesa/eselect-mesa.conf ]; then
		eerror "Rebuild media-libs/mesa for ${PN} to work."
	fi
}
