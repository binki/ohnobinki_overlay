# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# ebuild by Nathan Brink <ohnobinki@ohnopublishing.homelinux.net>
# don't trust it
# most of the following junk is derived of /var/cvsroot/gentoo-x86/net-fs/samba/samba-3.0.27.ebuild,v 1.11 and that is why I copied the header.txt file in also
# I need to get some smbspool program working...

inherit eutils pam libtool

SRC_URI="http://download.samba-tng.org/tng/${PV}/${P}.tar.gz"
SLOT="0"

#following line assumed :-(
LICENSE="GPL-2"

KEYWORDS="amd64 x86"

DESCRIPTION="A fork of samba emphasizing features over stability"
HOMEPAGE="http://www.samba-tng.org/"

#defaultedly use smbmount, defaultedly use --with-sam-pwdb=passdb, if nis will us nisplus-home, utempter activates utmp
IUSE="ldap msdfs afs dce-dfs krb4 kerberos automount pam nis syslog netatalk quotas utempter cups tcpwrapper"

ALLDEPEND="virtual/libiconv 
	ldap? ( net-nds/openldap )
        krb4? ( virtual/krb4 )
        kerberos? ( virtual/krb5 )
        pam? ( virtual/pam )
        syslog? ( virtual/logger )
        netatalk? ( net-fs/netatalk )
        cups? ( net-print/cups )
        tcpwrappers? ( sys-apps/tcp-wrappers )
        "
RDEPEND="${ALLDEPEND} !net-fs/samba"
#we can still build a binary package for it even if we have samba installed :-) :
DEPEND="${ALLDEPEND} "

PRIVATE_DST=/var/lib/samba-tng/private

src_unpack()
{
	unpack ${A}
	epatch "${FILESDIR}/${PV}"
}

add_to_list()
{
    LIST=$1
    TOADD=$2
    if ! [ -z "${LIST}" ]; then
	LIST="${LIST},"
    fi
    LIST="${LIST}${TOADD}"
    return ${LIST}
}

src_compile()
{
	cd "${S}/source"
	
	local WITH_PASSDB
	local WITH_SAMPWDB
	#local WITH_PASSDB_first
	#WITH_PASSDB_first=0
	WITH_PASSDB="smbpass"
	WITH_SAMPWDB="passdb,tdb"
	if use nis; then
	    #WITH_PASSDB="nisplus"
	    #WITH_PASSDB_first=1
	    #WITH_PASSDB=add_to_list "${WITH_PASSDB}" "nis,nisplus"
	    WITH_PASSDB="${PASSDB},nis,nisplus"
	fi
	if use ldap; then
	    #WITH_PASSDB=add_to_list "${WITH_PASSDB}" "ldap,nt5ldap"
	    WITH_PASSDB="${WITH_PASSDB},nt5ldap,ldap"
	    WITH_SMBPWDB="${WITH_SMBPWDB},nt5ldap"
	fi
	
	
	

	eautoreconf

	
	econf \
	    --program-suffix=-tng \
	    --sysconfdir=/etc/samba-tng \
	    --localstatedir=/var \
	    --libdir=/usr/$(get_libdir)/samba-tng \
	    --enable-shared=yes \
	    --enable-static=no \
	    --with-lockdir=/var/cache/samba-tng \
	    --with-logdir=/var/log/samba-tng \
            --with-privatedir=${PRIVATE_DST} \
	    --with-sambaconfdir=/etc/samba-tng \
	    --without-spinlocks \
	    $(use_with kernel_linux smbmount) \
            $(use_with ldap) \
	    $(use_with msdfs) \
	    --with-smbwrapper \
	    $(use_with afs) \
	    $(use_with dce-dfs) \
	    $(use_with krb4) \
	    $(use_with kerberos krb5) \
            $(use_with automount) \
	    $(use_with pam) \
	    $(use_with pam) \
	    $(use_with nis) \
	    --with-passdb=${WITH_PASSDB} \
	    --with-sam-pwdb=${WITH_SMBPWDB} \
	    $(use_with syslog) \
	    $(use_with quotas) \
            $(use_with utempter utmp) \
	    $(use_with cups) \
	    $(use_with tcpwrappers) || die "econf failed"


	emake clean proto all || die "unable to clean samba-tng"

	emake || die "emake failed"
}
src_install()
{
	cd "${S}/source"
	emake install DESTDIR="${D}" || die "emake install failed"

	diropts -m0700 ; keepdir ${PRIVATE_DST}

	#pam_ntdom doesn't build (but the pam use flag makes a passdb backend for pam?)
	if use pam ; then
            #dopammod pam_ntdom/pam_ntdom.so #this will soon work ?
	    #newpamd (put an example file so that samba's passdb backend works?)
 	    #no winbind support :-( use winbind && dopammod bin/pam_winbind.so
	    true;
 	fi
}
