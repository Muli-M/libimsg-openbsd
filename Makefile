#	Copyright (c) 2020, Muli Management P/L, Wahroonga, NSW, Australia

LIB=	imsg-openbsd
LIBDIR=	/usr/local/lib
MANDIR=	/usr/local/man
MAN=	imsg_init.3
SRCS=	imsg.c imsg-buffer.c freezero.c recallocarray.c
HDRS=	imsg.h
HDRDIR=	/usr/local/include
DEBUG=	-O0 -g

CPPFLAGS+=	-Wall -Werror -Wextra

PROJECT=	lib${LIB}
VERSION=	0.0.1
DISTDIR=	${.CURDIR}/${PROJECT}-${VERSION}
DISTFILES=	Makefile shlib_version ${HDRS} ${MAN} ${SRCS}
DIST_REG=	Makefile head_parse.c main.c reg.h

includes:
	@cd ${.CURDIR}; for i in ${HDRS}; do \
	    j="cmp -s $$i ${DESTDIR}${HDRDIR}/$$i || \
	    ${INSTALL} ${INSTALL_COPY} -o ${LIBOWN} -g ${LIBGRP} -m ${LIBMODE} \
		$$i ${DESTDIR}${HDRDIR}/"; \
	    echo $$j; \
	    eval "$$j"; \
	done

.depend: ${HDRS}

beforeinstall: includes

dist:
	rm -rf ${DISTDIR} ${DISTDIR}.tar.gz
	mkdir -p ${DISTDIR}/regress
	for i in ${DISTFILES}; do cp -p ${.CURDIR}/$$i ${DISTDIR}; done
	for i in ${DIST_REG}; do \
		cp -p ${.CURDIR}/regress/$$i ${DISTDIR}/regress; \
	done
	cd ${.CURDIR} && tar czf ${DISTDIR}.tar.gz ${PROJECT}-${VERSION}
	rm -rf ${DISTDIR}

distclean: clean
	rm -rf ${DISTDIR} ${DISTDIR}.tar.gz

test:
	cd ${.CURDIR}/regress && ${MAKE} clean obj depend regress

.include <bsd.lib.mk>
