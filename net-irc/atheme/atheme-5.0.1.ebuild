# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools base eutils flag-o-matic

MY_P=${PN}-services-${PV}
DESCRIPTION="A portable and secure set of open-source and modular IRC services"
HOMEPAGE="http://atheme.net/"
SRC_URI="http://atheme.net/downloads/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug largenet ldap pcre profile ssl"

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
	epatch "${FILESDIR}"/${P}-with-ldap.patch
	epatch "${FILESDIR}"/${P}-ldap-as-needed.patch
	epatch "${FILESDIR}"/${P}-depend-parallel.patch

	# fix atheme's sorry attempt at ``FHS paths'':
	sed -i -e 's;\(DATADIR=.*\)lib/;\1;' configure.ac || die

	eaclocal -I m4
	eautoheader
	eautoconf
}

src_configure() {
	econf --enable-fhs-paths \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use debug || echo --enable-propolice) \
		$(use_enable largenet large-net) \
		$(use_with ldap) \
		$(use_enable profile) \
		$(use_with pcre) \
		$(use_enable ssl)
}

src_install() {
	emake DESTDIR="${D}" install || die

	insinto /etc/${PN}
	for conf in dist/*.example; do
		newins ${conf} $(basename ${conf} .example)  || die "installing ${conf/.example//}"
	done

	fowners -R root:atheme /etc/atheme/ \
		/var/lib/{run/,log/,}${PN} || die
}