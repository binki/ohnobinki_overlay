# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

#base must be last to get base_src_prepare()
inherit java-pkg-opt-2 multilib toolchain-funcs versionator base

MY_PV="$(get_major_version)$(get_version_component_range 2)"
MY_PN="Phidgetlinux"

DESCRIPTION="Phidget USB hardware interface library"
HOMEPAGE="http://www.phidgets.com"
SRC_URI="http://www.phidgets.com/downloads/libraries/${MY_PN}_${PV}.tar.gz
	java? ( http://www.phidgets.com/downloads/libraries/phidget${MY_PV}jar_${PV}.zip )"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="java"

DEPEND="java? ( virtual/jdk
		app-arch/unzip )"
RDEPEND="java? ( virtual/jre )"

S=${WORKDIR}/${MY_PN}/${PN}${MY_PV}

PATCHES=( "${FILESDIR}"/${PN}${MY_PV}-gentoo.patch )

src_compile() {
	local javaflags usejava maketarget
	if use java; then
		javaflags="$(java-pkg_get-jni-cflags)"
		usejava=y
		maketarget=jni
	else
		javaflags=
		usejava=n
		maketarget=all
	fi

	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" JAVA="${usejava}" JAVAFLAGS="${javaflags}" ${maketarget} || die
}

src_install() {
	#phidget's Makefile's install target requires that these dirs exist
	dodir /usr/{$(get_libdir),include} || die

	local usejava
	use java && usejava=y || usejava=n
	emake install INSTALLPREFIX="${D}" PREFIX=usr LIBDIR=$(get_libdir) JAVA=${usejava} || die

	if use java; then
		java-pkg_regso "${D}"/usr/$(get_libdir)/lib${PN}${MY_PV}.so
		java-pkg_dojar "${WORKDIR}/phidget${MY_PV}.jar"
	fi

	dodoc ../README udev/99-phidgets.rules || die
	docinto examples
	dodoc examples/* || die
}
