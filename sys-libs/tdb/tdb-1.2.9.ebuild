# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/tdb/tdb-1.2.9.ebuild,v 1.2 2011/06/27 20:11:47 vostorga Exp $

EAPI=3
PYTHON_DEPEND="python? 2"

inherit eutils waf-utils python

DESCRIPTION="A simple database API"
HOMEPAGE="http://tdb.samba.org/"
SRC_URI="http://samba.org/ftp/tdb/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="python"

RDEPEND=""
DEPEND="dev-lang/python
	app-text/docbook-xml-dtd:4.2"

# In case if waf-utils.eclass actually accepts waf-utils_waflibdir() as
# a function. bug #367291.
unset waf-utils_waflibdir 2>/dev/null

# @FUNCTION: waf-utils_waflibdir
# @USAGE: [<waf-binary>]
# @DESCRIPTION:
# Echoes the absolute path to the directory containing waf-based
# project's waflib python module. Ensures that the waflib shipped with a
# project is unpacked if it isn't already. This waflib may be safely
# patched because waf-lite will not touch the waflib directory when it
# is run if it already exists. Uses the waf binary in WAF_BINARY or the
# first argument.
#
# @EXAMPLE
# @CODE
# pushd "$(waf-utils_waflibdir)" || die "Unable to patch waflib"
# epatch "${FILESDIR}"/${P}-waf-fix.patch
# popd
# @CODE
#
# Note that if you are using the python eclass, you must either call
# python_set_active_version or call waf-utils_waflibdir() from within a
# function run by python_execute().
#
# @CODE
# SUPPORT_PYTHON_ABIS=1
# inherit python
#
# src_prepare() {
# 	python_copy_sources
#
# 	myprepare() {
# 		epatch "${FILESDIR}"/${P}-sourcecode-fix.patch
#
# 		pushd "$(waf-utils_saflibdir "$(PYTHON)" waf)" || die "Unable to patch waflib"
# 		epatch "${FILESDIR}"/${P}-waf-fix.patch
# 		popd
# 	}
# 	python_execute_function -s myprepare
# }
# @CODE
waf-utils_waflibdir() {
	debug-print-function ${FUNCNAME} "$@"

	# @ECLASS-VARIABLE: WAF_BINARY
	# @DESCRIPTION:
	# Eclass can use different waf executable. Usually it is located in "${S}/waf".
	: ${WAF_BINARY:="${S}/waf"}

	local waf_binary=${WAF_BINARY}
	[[ -n ${1} ]] && waf_binary=${1}

	python -c "import imp, sys; sys.argv[0] = '${waf_binary}'; waflite = imp.load_source('waflite', '${waf_binary}'); print(waflite.find_lib());" \
		|| die "Unable to locate or unpack waflib module from the waf script at ${waf_binary}"
}

WAF_BINARY="${S}/buildtools/bin/waf"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	cd "$(waf-utils_waflibdir)" || die "Unable to patch waflib."
	epatch "${FILESDIR}"/talloc-2.0.5-waf-multilib.patch
}

src_configure() {
	local extra_opts=""
	use python || extra_opts+=" --disable-python"
	waf-utils_src_configure \
	${extra_opts}
}

src_test() {
	# the default src_test runs 'make test' and 'make check', letting
	# the tests fail occasionally (reason: unknown)
	emake check || die "emake check failed"
}
