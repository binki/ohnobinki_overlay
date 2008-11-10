# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="An XML-Java binding tool"
HOMEPAGE="http://xmlbeans.apache.org/"
SRC_URI="http://mirror.olnevhost.net/pub/apache/xmlbeans/source/xmlbeans-${PV}-src.tgz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~x86-fbsd"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.4
	=dev-java/jaxen-1.1*"

DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.6.2
	source? ( app-arch/zip )
	${RDEPEND}"

S=${WORKDIR}/xmlbeans-${PV}/

src_unpack() {
	unpack ${A}
	cd ${S}
#	epatch ${FILESDIR}/xml-xmlbeans-gentoo.patch

	java-ant_rewrite-classpath build.xml

	cd ${S}/external/lib
	#TODO: includes and old copy named oldxbean.jar
	#that probably should not be used
	#rm -v *.jar

	java-pkg_jar-from jaxen-1.1 jaxen.jar jaxen-1.1-beta-2.jar
}

src_compile() {
	eant xbean.jar $(use_doc docs) \
		-Dgentoo.classpath=$(java-pkg_getjars ant-core)
}

# Tests always seem to fail #100895

src_install() {
	java-pkg_dojar build/lib/xbean*.jar

	dodoc CHANGES.txt NOTICE.txt README.txt
	if use doc; then
		java-pkg_dojavadoc build/docs/reference
		java-pkg_dohtml -r docs
	fi
	use source && java-pkg_dosrc src/*
}
