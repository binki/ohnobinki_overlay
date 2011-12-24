# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/apache/apache-2.2.21-r1.ebuild,v 1.7 2011/10/29 18:46:16 armin76 Exp $

# latest gentoo apache files
GENTOO_PATCHSTAMP="20111018"
GENTOO_DEVELOPER="pva"
# We want the patch from r0
GENTOO_PATCHNAME="gentoo-${P}-r1"

# IUSE/USE_EXPAND magic
IUSE_MPMS_FORK="itk peruser prefork"
IUSE_MPMS_THREAD="event worker"

IUSE_MODULES="actions alias asis auth_basic auth_digest authn_alias authn_anon
authn_dbd authn_dbm authn_default authn_file authz_dbm authz_default
authz_groupfile authz_host authz_owner authz_user autoindex cache cern_meta
charset_lite cgi cgid dav dav_fs dav_lock dbd deflate dir disk_cache dumpio
env expires ext_filter file_cache filter headers ident imagemap include info
log_config log_forensic logio mem_cache mime mime_magic negotiation proxy
proxy_ajp proxy_balancer proxy_connect proxy_ftp proxy_http proxy_scgi rewrite
reqtimeout setenvif speling status substitute unique_id userdir usertrack
version vhost_alias"
# The following are also in the source as of this version, but are not available
# for user selection:
# bucketeer case_filter case_filter_in echo http isapi optional_fn_export
# optional_fn_import optional_hook_export optional_hook_import

# inter-module dependencies
# TODO: this may still be incomplete
MODULE_DEPENDS="
	dav_fs:dav
	dav_lock:dav
	deflate:filter
	disk_cache:cache
	ext_filter:filter
	file_cache:cache
	log_forensic:log_config
	logio:log_config
	mem_cache:cache
	mime_magic:mime
	proxy_ajp:proxy
	proxy_balancer:proxy
	proxy_connect:proxy
	proxy_ftp:proxy
	proxy_http:proxy
	proxy_scgi:proxy
	substitute:filter
"

# module<->define mappings
MODULE_DEFINES="
	auth_digest:AUTH_DIGEST
	authnz_ldap:AUTHNZ_LDAP
	cache:CACHE
	dav:DAV
	dav_fs:DAV
	dav_lock:DAV
	disk_cache:CACHE
	file_cache:CACHE
	info:INFO
	ldap:LDAP
	mem_cache:CACHE
	proxy:PROXY
	proxy_ajp:PROXY
	proxy_balancer:PROXY
	proxy_connect:PROXY
	proxy_ftp:PROXY
	proxy_http:PROXY
	ssl:SSL
	status:STATUS
	suexec:SUEXEC
	userdir:USERDIR
"

# critical modules for the default config
MODULE_CRITICAL="
	authz_host
	dir
	mime
"

inherit apache-2

DESCRIPTION="The Apache Web Server."
HOMEPAGE="http://httpd.apache.org/"
SRC_URI="${SRC_URI}
	http://opensource.mco2.net/download/apache/peruser/peruser-rc3-full-v16.patch"

# some helper scripts are Apache-1.1, thus both are here
LICENSE="Apache-2.0 Apache-1.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="peruser_max_cpu_usage peruser_pam"

# qemu-kvm required for libkvm for MaxCPUUsage, does this dep work?
DEPEND="${DEPEND}
	dev-util/difffilter
	>=dev-libs/openssl-0.9.8m
	apache2_modules_deflate? ( sys-libs/zlib )
	peruser_pam? ( virtual/pam )
	peruser_max_cpu_usage? ( app-emulation/qemu-kvm )"

# dependency on >=dev-libs/apr-1.4.5 for bug #368651
RDEPEND="${RDEPEND}
	>=dev-libs/apr-1.4.5
	>=dev-libs/openssl-0.9.8m
	apache2_modules_mime? ( app-misc/mime-types )"

pkg_setup() {
	apache-2_pkg_setup

	MY_CONF+=" $(use_enable peruser_max_cpu_usage) $(use_enable peruser_pam)"
}

src_prepare() {
	einfo "Replacing peruser 0.4.0rc2 patch with v16."
	rm -v "${GENTOO_PATCHDIR}"/patches/20_all_peruser_0.4.0-rc2.patch || die
	difffilter -e 'server/mpm/config\.m4' \
		< "${DISTDIR}"/peruser-rc3-full-v16.patch \
		> "${GENTOO_PATCHDIR}"/patches/20_peruser-rc3-full-v16.patch \
		|| die
	cp "${FILESDIR}"/${P}-peruser-config.m4.patch "${GENTOO_PATCHDIR}"/patches/20_peruser-config.m4.patch || die
	cp "${FILESDIR}"/${P}-peruser-makefile.patch "${GENTOO_PATCHDIR}"/patches/21_peruser-makefile.patch || die

	einfo "Fixing 21_all-itk-20110321.patch"
	sed -i \
		-e 's/"$apache_cv_mpm" = "event"/"$apache_cv_mpm" = "worker" -o &/' \
		-e 's/ -o "$apache_cv_mpm" = "peruser"/ -o "$apache_cv_mpm" = "winnt"&/' \
		"${GENTOO_PATCHDIR}"/patches/21_all-itk-20110321.patch || die

	apache-2_src_prepare
}
