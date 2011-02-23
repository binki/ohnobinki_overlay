# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/live/live-2009.06.02.ebuild,v 1.8 2010/01/06 16:55:17 ranger Exp $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs multilib

DESCRIPTION="Standards-based RTP/RTCP/RTSP multimedia streaming for embedded streaming applications"
HOMEPAGE="http://www.live555.com/"
SRC_URI="http://www.live555.com/liveMedia/public/${P/-/.}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="static-libs"

DEPEND="sys-devel/libtool:2"
RDEPEND=""

S=${WORKDIR}/${PN}

# Alexis Ballier <aballier@gentoo.org>
# Be careful, bump this everytime you bump the package and the ABI has changed.
# If you don't know, ask someone.
LIVE_ABI_VERSION=3

src_prepare() {
	cp "${FILESDIR}"/config.gentoo ./ || die
	epatch "${FILESDIR}"/${P}-as-needed.patch
	epatch "${FILESDIR}"/${P}-buildorder.patch
	epatch "${FILESDIR}"/${P}-libdeps.patch
}

src_configure() {
	tc-export CC CXX
	export LIVE_ABI_VERSION LIBDIR=/usr/$(get_libdir)

	if ! use static-libs; then
		append-flags -shared
		append-ldflags -shared
	fi

	./genMakefiles gentoo
}

src_compile() {
	einfo "Beginning library build"
	emake -j1 TESTPROGS_APP="" MEDIA_SERVER_APP="" || die "failed to build libraries"

	einfo "Beginning programs build"
	emake -C testProgs || die "failed to build test programs"
	emake -C mediaServer || die "failed to build the mediaserver"
}

src_install() {
	dodir /usr/{$(get_libdir),bin} || die
	for library in UsageEnvironment liveMedia BasicUsageEnvironment groupsock; do
		libtool --mode=install install -c ${library}/lib${library}.la "${D}"/usr/$(get_libdir)/ || die

		if ! use static-libs; then
			# make tommy happy --ohnobinki
			rm -v "${D}"/usr/$(get_libdir)/lib${library}.la || die
		fi

		insinto /usr/include/${library}
		doins ${library}/include/*h || die
	done

	# Should we really install these?
	find testProgs -type f -perm +111 \
		-exec libtool --mode=install install -c '{}' "${D}"/usr/bin/ \; || die

	#install included live555MediaServer application
	libtool --mode=install install -c mediaServer/live555MediaServer "${D}"/usr/bin/ || die

	# install docs
	dodoc README || die
}

pkg_postinst() {
	ewarn "If you are upgrading from a version prior to live-2008.02.08"
	ewarn "Please make sure to rebuild applications built against ${PN}"
	ewarn "like vlc or mplayer. ${PN} may have had ABI changes and ${PN}"
	ewarn "support might be broken."
}
