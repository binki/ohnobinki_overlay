# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit elisp-common toolchain-funcs eutils versionator flag-o-matic base cmake-utils

MY_P="${PN}-$(replace_version_separator 3 - ${MY_PV})"

DESCRIPTION="Cross platform Make"
HOMEPAGE="http://www.cmake.org/"
SRC_URI="http://www.cmake.org/files/v$(get_version_component_range 1-2)/${MY_P}.tar.gz"

LICENSE="CMake"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE="emacs ncurses qt4 vim-syntax"

DEPEND="
	>=app-arch/libarchive-2.8.0
	>=net-misc/curl-7.20.0-r1[ssl]
	>=dev-libs/expat-2.0.1
	sys-libs/zlib
	ncurses? ( sys-libs/ncurses )
	qt4? ( x11-libs/qt-gui:4 )
"
RDEPEND="${DEPEND}
	emacs? ( virtual/emacs )
	vim-syntax? (
		|| (
			app-editors/vim
			app-editors/gvim
		)
	)
"

SITEFILE="50${PN}-gentoo.el"
VIMFILE="${PN}.vim"

S="${WORKDIR}/${MY_P}"

CMAKE_BINARY="${S}/Bootstrap.cmk/cmake"
CMAKE_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.3-darwin-bundle.patch
	"${FILESDIR}"/${PN}-2.6.3-no-duplicates-in-rpath.patch
	"${FILESDIR}"/${PN}-2.6.3-fix_broken_lfs_on_aix.patch
	"${FILESDIR}"/${PN}-2.8.0-darwin-default-install_name.patch
	"${FILESDIR}"/${PN}-2.8.0-darwin-no-app-with-qt.patch
	"${FILESDIR}"/${PN}-2.8.1-FindBoost.patch
	"${FILESDIR}"/${PN}-2.8.1-libform.patch
	"${FILESDIR}"/${PN}-2.8.3-FindLibArchive.patch
	"${FILESDIR}"/${PN}-2.8.3-FindPythonLibs.patch
	"${FILESDIR}"/${PN}-2.8.3-FindPythonInterp.patch
	"${FILESDIR}"/${PN}-2.8.3-more-no_host_paths.patch
	"${FILESDIR}"/${PN}-2.8.3-ruby_libname.patch
	"${FILESDIR}"/${PN}-2.8.3-buffer_overflow.patch
	"${FILESDIR}"/${PN}-2.8.3-fix_assembler_test.patch
	"${FILESDIR}"/${PN}-2.8.1-portage-multilib-lib32.patch
)

_src_bootstrap() {
	  echo ${MAKEOPTS} | egrep -o '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+' > /dev/null
	  if [ $? -eq 0 ]; then
		  par_arg=$(echo ${MAKEOPTS} | egrep -o '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+' | egrep -o '[[:digit:]]+')
		  par_arg="--parallel=${par_arg}"
	  else
		  par_arg="--parallel=1"
	  fi

	tc-export CC CXX LD

	./bootstrap \
		--prefix="${T}/cmakestrap/" \
		${par_arg} \
		|| die "Bootstrap failed"
}

src_prepare() {
	base_src_prepare

	# disable bootstrap cmake and make run, we use eclass for that
	sed -i \
		-e '/"${cmake_bootstrap_dir}\/cmake"/s/^/#DONOTRUN /' \
		bootstrap || die "sed failed"

	# Add gcc libs to the default link paths
	sed -i \
		-e "s|@GENTOO_PORTAGE_GCCLIBDIR@|${EPREFIX}/usr/${CHOST}/lib/|g" \
		-e "s|@GENTOO_PORTAGE_EPREFIX@|${EPREFIX}/|g" \
		Modules/Platform/{UnixPaths,Darwin}.cmake || die "sed failed"

	_src_bootstrap
}

src_configure() {
	# make things work with gentoo java setup
	# in case java-config cannot be run, the variable just becomes unset
	# per bug #315229
	export JAVA_HOME=$(java-config -g JAVA_HOME 2> /dev/null)

	local mycmakeargs=(
		-DCMAKE_USE_SYSTEM_LIBRARIES=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DCMAKE_DOC_DIR=/share/doc/${PF}
		-DCMAKE_MAN_DIR=/share/man
		-DCMAKE_DATA_DIR=/share/${PN}
		$(cmake-utils_use_build ncurses CursesDialog)
		$(cmake-utils_use_build qt4 QtDialog)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use emacs; then
		elisp-compile Docs/cmake-mode.el || die "elisp compile failed"
	fi
}

src_test() {
	emake test || die "Tests failed"
}

src_install() {
	cmake-utils_src_install
	if use emacs; then
		elisp-install ${PN} Docs/cmake-mode.el Docs/cmake-mode.elc || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins Docs/cmake-syntax.vim || die

		insinto /usr/share/vim/vimfiles/indent
		doins Docs/cmake-indent.vim || die

		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}/${VIMFILE}" || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
