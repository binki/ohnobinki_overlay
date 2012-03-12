# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit prefix

DESCRIPTION="A simple hack to try to trick mit-krb5 into thinking the host has an FQDN"
HOMEPAGE="http://dev.gentoo.org/~binki/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-apps/net-tools
	>=sys-apps/openrc-0.9"

S=${WORKDIR}

src_install() {
	exeinto /etc/cron.hourly
	cp "${FILESDIR}"/${PN} "${T}"/ || die
	eprefixify "${T}"/${PN}
	doexe "${FILESDIR}"/${PN}

	exeinto /etc/local.d
	cat <<EOF > "${T}"/${PN}
#!${EPREFIX}/bin/bash
${EPREFIX}/etc/cron.hourly/${PN}
EOF
	doexe "${T}"/${PN}
}
