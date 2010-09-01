# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils flag-o-matic perl-module

MY_P=${PN}-services-${PV}
DESCRIPTION="A portable and secure set of open-source and modular IRC services"
HOMEPAGE="http://atheme.net/"
SRC_URI="http://atheme.net/downloads/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug largenet ldap pcre perl profile ssl"

RDEPEND="dev-libs/libmowgli
	ldap? ( net-nds/openldap )
	pcre? ( dev-libs/libpcre )
	ssl? ( dev-libs/openssl )"
DEPEND="${DEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	# the dependency calculation puts all of the .c files together and
	# overwhelms cc1 with this flag :-(
	filter-flags -combine

	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-LDFLAGS.patch

	# fix docdir
	sed -i -e 's/\(^DOCDIR.*=.\)@DOCDIR@/\1@docdir@/' extra.mk.in || die

	# basic logging config directive fix
	sed -i -e 's;var/\(.*\.log\);\1;g' dist/* || die

	# QA against bundled libs
	rm -rf libmowgli || die
}

src_configure() {
	econf --enable-fhs-paths \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--localstatedir="${EPREFIX}"/var \
		$(use debug || echo --enable-propolice) \
		$(use_enable largenet large-net) \
		$(use_with ldap) \
		$(use_enable profile) \
		$(use_with pcre) \
		$(use_enable ssl)
}

src_compile() {
	emake || die
	emake -C contrib || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	emake DESTDIR="${D}" -C contrib install || die

	insinto /etc/${PN}
	for conf in dist/*.example; do
		newins ${conf} $(basename ${conf} .example)  || die "installing ${conf/.example//}"
	done

	fowners -R root:atheme /etc/atheme || die
	fowners atheme:atheme /var/{lib,run,log}/${PN} || die
	fperms -R 640 /etc/atheme || die
	fperms 750 /etc/atheme /var/{lib,run,log}/${PN} || die

	newinitd "${FILESDIR}"/${PN}.initd atheme || die

	# contributed scripts and such:
	insinto /usr/share/doc/${PF}/contrib
	doins contrib/*.{pl,php,py,rb} || die
	# various conversion programs
	doins contrib/{anope_convert.c,ircs_crypto_trans.c} || die

	if use perl; then
		perlinfo
		insinto "${VENDOR_LIB}"
		doins -r contrib/Atheme{,.pm} || die
	fi
}
