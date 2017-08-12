IDRIS_VERSION = 1.1.1
PWD = $(shell pwd)
REPO = "irreverentpixelfeats/idris-build"
BASE_TAG = "ubuntu_xenial_${IDRIS_VERSION}"

tars/idris-${IDRIS_VERSION}.tar.gz:
	cd lib/src && (tar czvf ${PWD}/tars/idris-${IDRIS_VERSION}.tar.gz IDRIS-${IDRIS_VERSION} > /dev/null)

git-sha:
	bin/git-version ./latest-version
	diff -q latest-version data/version || cp -v latest-version data/version
	rm latest-version

deps: git-sha tars/idris-${IDRIS_VERSION}.tar.gz

build: deps Dockerfile
	docker build --cache-from "${REPO}:${BASE_TAG}" --tag "${REPO}:${BASE_TAG}" --tag "${REPO}:${BASE_TAG}-$(shell cat data/version)" .

images/idris-build-${BASE_TAG}.tar.gz: build
	docker image save -o "images/idris-build-${BASE_TAG}.tar" "${REPO}:${BASE_TAG}"
	cd images && gzip -v "idris-build-${BASE_TAG}.tar"

image: images/idris-build-${BASE_TAG}.tar.gz

all: build image
