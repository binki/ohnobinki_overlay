# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/acl/acl-2.2.39-r1.ebuild,v 1.12 2007/01/31 20:47:08 dertobi123 Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils autotools toolchain-funcs

MY_P="${PN}_${PV}-1"
DESCRIPTION="Access control list utilities, libraries and headers"
HOMEPAGE="http://oss.sgi.com/projects/xfs/"
SRC_URI="ftp://oss.sgi.com/projects/xfs/download/cmd_tars/${MY_P}.tar.gz
	ftp://xfs.org/mirror/SGI/cmd_tars/${MY_P}.tar.gz
	nfs? ( http://www.citi.umich.edu/projects/nfsv4/linux/acl-patches/2.2.29-3/acl-2.2.29-CITI_NFS4_ALL-3.dif )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="nfs nls"

RDEPEND=">=sys-apps/attr-2.4
	nfs? ( net-libs/libnfsidmap )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd "${S}"
	if use nfs ; then
		cp "${DISTDIR}"/acl-2.2.29-CITI_NFS4_ALL-3.dif . || die
		epatch \
			"${FILESDIR}"/acl-2.2.29-nfs-glue.patch \
			acl-2.2.29-CITI_NFS4_ALL-3.dif
	fi
	epatch "${FILESDIR}"/${PN}-2.2.32-only-symlink-when-needed.patch
	epatch "${FILESDIR}"/attr-2.4.32-libtool.patch
	epatch "${FILESDIR}"/${P}-leave-las-to-libtool.patch

	sed -i \
		-e "/^PKG_DOC_DIR/s:@pkg_name@:${PF}:" \
		-e '/HAVE_ZIPPED_MANPAGES/s:=.*:=false:' \
		include/builddefs.in \
		|| die "failed to update builddefs"
	AT_M4DIR="m4" eaclocal
	_elibtoolize --copy --force
	AT_M4DIR="m4" eaclocal
	eautoconf
}

src_compile() {
	export OPTIMIZER=${CFLAGS}
	export DEBUG=-DNDEBUG

	econf \
		$(use_enable nls gettext) \
		--libexecdir=/usr/$(get_libdir) \
		--bindir=/bin \
		|| die
	emake || die
}

src_install() {
	emake DIST_ROOT="${D}" install install-dev install-lib || die
	prepalldocs

	# move shared libs to /
	dodir /$(get_libdir)
	mv "${D}"/usr/$(get_libdir)/libacl.so* "${D}"/$(get_libdir)/ || die
	gen_usr_ldscript libacl.so
}
