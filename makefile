# Makefile for the libimsg-openbsd package

MULI_TAG?=1.1
ARCH=`dpkg --print-architecture`

debian: makefile control_tmpl
	bmake -m /usr/local/share/openbsd-mk -f Makefile
	rm -rf debian
	mkdir -p debian/DEBIAN
	mkdir -p debian/usr/local/include
	mkdir -p debian/usr/local/lib
	mkdir -p debian/usr/local/man/man3
	DESTDIR=$(shell pwd)/debian fakeroot bmake -f Makefile install

	# control
	echo "Version: ${MULI_TAG}" > debian/DEBIAN/control
	echo "Architecture: ${ARCH}" >> debian/DEBIAN/control
	cat control_tmpl >> debian/DEBIAN/control

	# debian scripts
#	install -D preinst debian/DEBIAN
#	install -D postinst debian/DEBIAN


	fakeroot dpkg-deb --build debian .

clean:
	bmake -f Makefile clean
	rm -f *~ *.deb
	rm -rf debian

.DEFAULT:
	bmake -m /usr/local/share/openbsd-mk -f Makefile $@
