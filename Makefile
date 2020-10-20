ARCH := $(shell getconf LONG_BIT)

CPP_FLAGS_32 := 32
CPP_FLAGS_64 := 64
ALIAS_32 := 86
ALIAS_64 := 64

ARCHX := x$(CPP_FLAGS_$(ARCH))
ALIASX := x$(ALIAS_$(ARCH))
ARCHDIR := win$(CPP_FLAGS_$(ARCH))

NGINX_VERSION=1.19.3
NSSM_VERSION=2.24-101-g897c7ad
NODE_VERSION=12.19.0
current_dir = $(shell pwd)

NGINX_LINK=http://nginx.org/download/nginx-$(NGINX_VERSION).zip
NGINX_PKG=nginx-$(NGINX_VERSION)

NSSM_LINK=http://nssm.cc/ci/nssm-$(NSSM_VERSION).zip
NSSM_PKG=nssm-$(NSSM_VERSION)

NODE_LINK=https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-win-${ALIASX}.zip
NODE_PKG=node-v${NODE_VERSION}-win-${ALIASX}

#$(info $(ARCHX) $(ARCHDIR) $(ALIASX) $(NODE_LINK))

BIN=build/nginx-service.exe

# clean all $(BIN)
.PHONY: deps/$(NGINX_PKG)/* deps/$(NSSM_PKG)/* deps/${NODE_PKG}/* $(BIN)

$(BIN): #deps/$(NGINX_PKG)/* deps/$(NSSM_PKG)/* deps/${NODE_PKG}/*
	rm -rf build
	rm -rf tmp
	mkdir build
	mkdir tmp
	cp -r deps/${NODE_PKG}/* tmp/
	cp -r deps/$(NGINX_PKG)/* tmp/
	cp deps/$(NSSM_PKG)/${ARCHDIR}/nssm.exe tmp/nssm.exe
	cp -r src/* tmp/
	cp -r ngrok tmp/
	cp -r add-on/* tmp/
	mv tmp/conf/nginx.conf tmp/conf/nginx.conf.orig
	cd tmp && makensis nginx.nsi
	mv tmp/nginx-service.exe build/nginx-service.exe

deps/${NODE_PKG}/*: deps/${NODE_PKG}.zip
	rm -rf deps/${NODE_PKG}/
	unzip deps/${NODE_PKG}.zip -d deps/

deps/$(NGINX_PKG)/*: deps/$(NGINX_PKG).zip
	rm -rf deps/$(NGINX_PKG)/
	unzip deps/$(NGINX_PKG).zip -d deps/

deps/$(NSSM_PKG)/*: deps/$(NSSM_PKG).zip
	rm -rf deps/$(NSSM_PKG)/
	unzip deps/$(NSSM_PKG).zip -d deps/

deps/${NODE_PKG}.zip:
	cd deps && wget ${NODE_LINK}

deps/$(NGINX_PKG).zip:
	cd deps && wget $(NGINX_LINK)

deps/$(NSSM_PKG).zip:
	cd deps && wget $(NSSM_LINK)

clean:
	#rm -rf deps/*
	rm -rf build/*
	rm -rf tmp/*

all: clean $(BIN)
