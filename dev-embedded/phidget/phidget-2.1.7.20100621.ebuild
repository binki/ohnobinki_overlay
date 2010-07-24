# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib versionator

MY_PV="$(get_major_version)$(get_version_component_range 2)"
MY_PN="libphidget"

DESCRIPTION="Phidget USB hardware interface library"
HOMEPAGE="http://www.phidgets.com"
SRC_URI="http://www.phidgets.com/downloads/libraries/${MY_PN}_${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi debug java"

S=${WORKDIR}/${MY_PN}-${PV}

# It can build against internal JNI headers and provide a JNI .so. That doesn't
# mean that the main lib suddenly needs java just to run ;-).
DEPEND="java? ( app-arch/unzip )"
RDEPEND=""

src_configure() {
	econf \
		$(use_enable avahi zeroconf) \
		$(use_enable debug) \
		$(use_enable java jni) \
		--disable-ldconfig
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc README udev/99-phidgets.rules || die
	docinto examples
	dodoc examples/* || die
}
