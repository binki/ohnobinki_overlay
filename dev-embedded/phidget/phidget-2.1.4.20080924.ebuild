# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator eutils java-pkg-opt-2

DESCRIPTION="Phidget USB hardware interface library"
MY_PV="$(get_major_version)$(get_version_component_range 2)"
LONGNAME="Phidgetlinux"
SRC_URI="http://www.phidgets.com/downloads/libraries/${LONGNAME}_${PV}.tar.gz"
HOMEPAGE="http://www.phidgets.com"

SLOT="0"

LICENSE="LGPL"
KEYWORDS="x86 ~alpha ~ppc ~sparc ~hppa ~amd64"

RDEPEND="java? ( >=virtual/jre-1.4 )"
DEPEND="java? ( >=virtual/jdk-1.4 )"

S=${WORKDIR}/${LONGNAME}/${PN}${MY_PV}

src_unpack() {
	unpack ${LONGNAME}_${PV}.tar.gz
	cd "${S}"

	epatch "${FILESDIR}"/${PN}${MY_PV}-libdir.patch
	epatch "${FILESDIR}"/${PN}${MY_PV}-crosscompile.patch
	use java && epatch "${FILESDIR}"/${PN}${MY_PV}-java.patch
}

src_compile() {
	echo cd "${S}"
	cd "${S}"
	if use java; then
		emake CROSS_COMPILE=${CHOST}- JAVA=y JAVAFLAGS="$(java-pkg_get-jni-cflags)" jni || die "emake failed"
	else
		emake CROSS_COMPILE=${CHOST}- JAVA=n || die "emake failed"
	fi
}

src_install() {

	#it seems that phidget's install stuff wants these dirs to exist
	mkdir -p ${D}/usr/$(get_libdir) && \
		mkdir -p ${D}/usr/include || die "mkdir failed in creation of destination directories"
	emake install INSTALLPREFIX=${D} PREFIX=usr LIBDIR=$(get_libdir) || die "emake install failed"
	use java && java-pkg_regso "${D}"/usr/$(get_libdir)/lib${PN}${MY_PV}.so || die "registering java .so file failed"
}
