# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/live/live-2009.11.12.ebuild,v 1.1 2009/11/21 12:23:51 aballier Exp $

EAPI="2"

inherit eutils flag-o-matic eutils toolchain-funcs multilib

DESCRIPTION="Standards-based RTP/RTCP/RTSP multimedia streaming for embedded streaming applications"
HOMEPAGE="http://www.live555.com/"
SRC_URI="http://www.live555.com/liveMedia/public/${P/-/.}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs"

S=${WORKDIR}/${PN}

# Alexis Ballier <aballier@gentoo.org>
# Be careful, bump this everytime you bump the package and the ABI has changed.
# If you don't know, ask someone.
LIVE_ABI_VERSION=3

src_prepare() {
	cp "${FILESDIR}"/config.gentoo ./ || die
	epatch "${FILESDIR}"/${PN}-2009.09.28-buildorder.patch
	epatch "${FILESDIR}"/${PN}-2009.06.02-libdeps.patch
	epatch "${FILESDIR}"/${PN}-recursive.patch

	# copied from portage's live-2009-11.*.ebuild ->
	# live-2010.04.09.ebuild diff, not gauranteed to work. Please file
	# bugs at http://ohnopub.net/bugzilla against ohnobinki_overlay.
	case ${CHOST} in
		*-solaris*)
			sed -i \
				-e '/^COMPILE_OPTS /s/$/ -DSOLARIS/' \
				-e '/^LIBS_FOR_CONSOLE_APPLICATION /s/$/ -lsocket -lnsl/' \
				live-static/config.gentoo \
				live-shared/config.gentoo-so-r1 \
				|| die "Please file bug at http://ohnopub.net/bugzilla"
		;;
		*-darwin*)
			sed -i \
				-e '/^COMPILE_OPTS /s/$/ -DBSD=1 -DHAVE_SOCKADDR_LEN=1/' \
				-e '/^LINK /s/$/ /' \
				-e '/^LIBRARY_LINK /s/$/ /' \
				-e '/^LIBRARY_LINK_OPTS /s/-Bstatic//' \
				live-static/config.gentoo \
				|| die "static Please file bug at http://ohnopub.net/bugzilla"
			sed -i \
				-e '/^COMPILE_OPTS /s/$/ -DBSD=1 -DHAVE_SOCKADDR_LEN=1/' \
				-e '/^LINK /s/$/ /' \
				-e '/^LIBRARY_LINK /s/=.*$/= $(CXX) -o /' \
				-e '/^LIBRARY_LINK_OPTS /s:-shared.*$:-undefined suppress -flat_namespace -dynamiclib -install_name '"${EPREFIX}/usr/$(get_libdir)/"'$@:' \
				live-shared/config.gentoo-so-r1 \
				|| die "shared Please file bug at http://ohnopub.net/bugzilla"
		;;
	esac

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
	emake -j1 || die "failed to build libraries"

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

	#install included live555MediaServer aplication
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
