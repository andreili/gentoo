# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit texlive-common

DESCRIPTION="DVI-to-PostScript translator"
HOMEPAGE="https://tug.org/texlive/"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/texlive/texlive-${PV#*_p}-source.tar.xz"

TL_VERSION=2021
EXTRA_TL_MODULES="dvips"
EXTRA_TL_DOC_MODULES="dvips.doc"

for i in ${EXTRA_TL_MODULES} ; do
	SRC_URI="${SRC_URI} https://dev.gentoo.org/~sam/distfiles/texlive/tl-${i}-${TL_VERSION}.tar.xz"
done

SRC_URI="${SRC_URI} doc? ( "
for i in ${EXTRA_TL_DOC_MODULES} ; do
	SRC_URI="${SRC_URI} https://dev.gentoo.org/~sam/distfiles/texlive/tl-${i}-${TL_VERSION}.tar.xz"
done
SRC_URI="${SRC_URI} ) "

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc source"

DEPEND=">=dev-libs/kpathsea-6.2.1:="

BDEPEND="virtual/pkgconfig"

S=${WORKDIR}/texlive-${PV#*_p}-source/texk/${PN}

src_configure() {
	econf --with-system-kpathsea
}

src_install() {
	emake DESTDIR="${D}" prologdir="${EPREFIX}/usr/share/texmf-dist/dvips/base" install

	dodir /usr/share # just in case
	cp -pR "${WORKDIR}"/texmf-dist "${ED}/usr/share/" || die "failed to install texmf trees"
	if use source ; then
		cp -pR "${WORKDIR}"/tlpkg "${ED}/usr/share/" || die "failed to install tlpkg files"
	fi

	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	etexmf-update
}

pkg_postrm() {
	etexmf-update
}
