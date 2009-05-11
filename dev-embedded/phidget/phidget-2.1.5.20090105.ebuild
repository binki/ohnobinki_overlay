# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

#base must be last to get base_src_prepare()
inherit versionator multilib java-pkg-opt-2 base

MY_PV="$(get_major_version)$(get_version_component_range 2)"
MY_PN="Phidgetlinux"

DESCRIPTION="Phidget USB hardware interface library"
HOMEPAGE="http://www.phidgets.com"
SRC_URI="http://www.phidgets.com/downloads/libraries/${MY_PN}_${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="java"

DEPEND="java? ( >=virtual/jdk-1.4 )"
RDEPEND="java? ( >=virtual/jre-1.4 )"

S=${WORKDIR}/${MY_PN}/${PN}${MY_PV}

PATCHES=( "${FILESDIR}"/${PN}${MY_PV}-libdir.patch \
	"${FILESDIR}"/${PN}${MY_PV}-crosscompile.patch \
	"${FILESDIR}"/${PN}${MY_PV}-java.patch )

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

	emake CROSS_COMPILE=${CHOST}- JAVA="${usejava}" JAVAFLAGS="${javaflags}" "${maketarget}" || die "emake failed"
}

src_install() {

	#phidget's Makefile's install target requires that these dirs exist
	dodir /usr/$(get_libdir) && \
		dodir /usr/include || die "mkdir failed to create installation target directories"

	local usejava
	use java && usejava=y || usejava=n
	emake install INSTALLPREFIX="${D}" PREFIX=usr LIBDIR=$(get_libdir) JAVA=${usejava} \
		|| die "emake install failed"

	use java && java-pkg_regso "${D}"/usr/$(get_libdir)/lib${PN}${MY_PV}.so

	dodoc ../README udev/99-phidgets.rules || die
	docinto examples
	dodoc examples/* || die "failed to install examples"
}
