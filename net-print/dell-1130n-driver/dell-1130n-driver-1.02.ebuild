# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4

inherit multilib

DESCRIPTION="PPDs for Dell 1130n"
HOMEPAGE="http://dell.com/support/drivers/us/en/19/DriverDetails/DriverFileFormats?DriverId=R264079&FileId=2731111948"
SRC_URI="ftp://ftp.dell.com/printer/Dell1130n_Linux_WP_${PV}.tar.gz"

LICENSE="Dell"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE=""

S=${WORKDIR}/cdroot/Linux

RDEPEND=">=net-print/samsung-unified-linux-driver-1.02"

src_install() {
	insinto /usr/share/ppd/dell
	doins noarch/at_opt/share/ppd/*.ppd
}
