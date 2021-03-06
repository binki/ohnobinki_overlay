# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/apr-util/apr-util-1.3.9.ebuild,v 1.12 2009/11/04 12:12:05 arfrever Exp $

EAPI="2"

inherit multilib

DESCRIPTION="Samsung's proprietary printer driver binaries known as UnifiedLinuxDriver"
HOMEPAGE="http:///www.samsung.com/us/support/downloads/CLX-3175FW/XA"
SRC_URI="http://org.downloadcenter.samsung.com/downloadfile/ContentsFile.aspx?VPath=DR/200911/20091118142757906/UnifiedLinuxDriver_1.01.tar.gz -> ${P}.tar.gz"

LICENSE="SAMSUNG-ELECTRONICS-software"
SLOT="0"
# x86 should be supported, but we have to do -* because only x86/amd64
# is supported.
KEYWORDS="~amd64 -*"
IUSE="doc test"

S=${WORKDIR}/cdroot/Linux

DEPEND="dev-util/bin_replace_string"
# We need libstdc++.so.5
RDEPEND="net-print/cups
	sys-libs/libstdc++-v3"

QA_PRESTRIPPED='/usr/libexec/cups/filter/rastertosamsung.* /usr/lib[0-9]*/libscmssc.so'
QA_SONAME='/usr/lib[0-9]*/libscmssc.so'

pkg_setup() {
	local abi="${ABI}"

	# does non-portage-multilib take significance in ${ABI}?
	[ -z "${abi}" ] && abi="${ARCH}"

	# Samsung's choice for how to denote ABIs and libdir within its
	# tarball.
	case ${abi} in
		x86)
			SABI=i386
			SLIBDIR=lib
			;;
		amd64)
			SABI=x86_64
			SLIBDIR=lib64
			;;
		*)
			die "Unable to understand the following value of \${ABI} or \${ARCH}: \`\`${abi}''"
			;;
	esac
}

src_prepare() {
	# The rasterto* cups filters will dlopen() libscmssc.so. However,
	# they try to open it at /usr/lib/cups/filter/libscmssc.so,
	# /usr/lib64/cups/filter/libscmssc.so, and finally
	# ../src/libscmssc.so. We thus hack the first entry to not use an
	# absolute path and just throw this binary into the library search
	# path. If these filters fail to dlopen() libscmssc.so, the
	# printer will print two copies of each page on each page with
	# white horizonal bands.
	for filter in ${SABI}/at_root/usr/${SLIBDIR}/cups/filter/rasterto*; do
		bin_replace_string /usr/lib/cups/filter/libscmssc.so libscmssc.so ${filter} || die
	done
}

src_install() {
	# Currently, we try to install the minimum necessary for
	# integrating into CUPS. The UI may come later with a qt4
	# useflag... but having a working driver is much more useful than
	# a GUI.

	insinto /usr/share
	doins -r noarch/at_opt/share/images || die

	insinto /usr/share/ppd
	doins noarch/at_opt/share/ppd/*.ppd || die

	# rastertosamsungsplc looks for the *.cts file here of its own
	# arbitrary choosing.
	insinto /usr/share/cups/model/samsung
	doins -r noarch/at_opt/share/ppd/cms || die

	# I think that sane support needs the smfpd to be installed and
	# running...(?)
	insinto /etc/sane.d
	doins -r noarch/at_root/etc/sane.d/* || die

	# required only for scanning?
	#dosbin ${SABI}/at_root/usr/sbin/smfpd || die

	exeinto /usr/libexec/cups/filter
	doexe ${SABI}/at_root/usr/${SLIBDIR}/cups/filter/rasterto* || die

	# see comment in src_prepare() about libscmssc.so; libscmssc.so
	# must currently be placed into the system library search path to
	# be found.
	dolib ${SABI}/at_root/usr/${SLIBDIR}/cups/filter/libscmssc.so || die
}
