# Makefile for the libimsg-openbsd package

MULI_TAG?=1.3
ARCH=`dpkg --print-architecture`
major = $(firstword $(subst ., ,$1))
minor = $(word 2,$(subst ., ,$1))

debian: makefile debian/control Makefile shlib_version
	bmake -f Makefile
	rm -rf debian/tmp
	mkdir -p debian/tmp/DEBIAN
	mkdir -p debian/tmp/usr/local/include
	mkdir -p debian/tmp/usr/local/lib
	mkdir -p debian/tmp/usr/local/man/man3
	DESTDIR=$(shell pwd)/debian/tmp fakeroot bmake -f Makefile install

	# generate changelog from git log
	gbp dch
	sed -i "/UNRELEASED;/s/unknown/${MULI_TAG}/" debian/changelog
	# generate dependencies
	dpkg-shlibdeps -l/usr/local/lib debian/tmp/usr/local/lib/libimsg-openbsd.so
	# generate symbols file
	dpkg-gensymbols
	# generate md5sums file
	find debian/tmp/ -type f -exec md5sum '{}' + | grep -v DEBIAN | sed s#debian/tmp/## > debian/tmp/DEBIAN/md5sums
	# control
	dpkg-gencontrol -v${MULI_TAG}

	# creating .deb package
	fakeroot dpkg-deb --build debian/tmp .

shlib_version: makefile
	echo "major=$(call major,${MULI_TAG})" > $@
	echo "minor=$(call minor,${MULI_TAG})" >> $@


clean:
	bmake -f Makefile clean
	rm -f *~ *.deb
	rm -rf debian/tmp

.DEFAULT:
	bmake -f Makefile $@

.PHONY: clean debian
