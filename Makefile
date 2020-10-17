NGINX_VERSION=1.19.3
NSSM_VERSION=2.24-101-g897c7ad
current_dir = $(shell pwd)
NGINX_LINK=http://nginx.org/download/nginx-$(NGINX_VERSION).zip
NGINX_PKG=nginx-$(NGINX_VERSION)

NSSM_LINK=http://nssm.cc/ci/nssm-$(NSSM_VERSION).zip
NSSM_PKG=nssm-$(NSSM_VERSION)

BIN= build/nginx-service.exe

.PHONY: clean all $(BIN)

ARCH = win32

ifeq ($(OS),Windows_NT)
    ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
        ARCH = win64
    else
        ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
            ARCH = win64
        endif
        ifeq ($(PROCESSOR_ARCHITECTURE),x86)
            ARCH = win32
        endif
    endif
endif

$(BIN): deps/$(NGINX_PKG)/* deps/$(NSSM_PKG)/*
	cp -r deps/$(NGINX_PKG)/* tmp/
	cp deps/$(NSSM_PKG)/${ARCH}/nssm.exe tmp/nssm.exe
	cp -r src/*  tmp/
	mv tmp/conf/nginx.conf tmp/conf/nginx.conf.orig
	cp -r add-on/* tmp/
	cd tmp && makensis nginx.nsi
	mv tmp/nginx-service.exe build/nginx-service.exe

deps/$(NGINX_PKG)/*: deps/$(NGINX_PKG).zip
	rm -rf deps/$(NGINX_PKG)/
	unzip deps/$(NGINX_PKG).zip -d deps/

deps/$(NSSM_PKG)/*: deps/$(NSSM_PKG).zip
	rm -rf deps/$(NSSM_PKG)/
	unzip deps/$(NSSM_PKG).zip -d deps/

deps/$(NGINX_PKG).zip:
	ifeq (,$(wildcard ./deps/$(NGINX_PKG).zip))
		cd deps && wget $(NGINX_LINK)
	endif

deps/$(NSSM_PKG).zip:
	ifeq (,$(wildcard ./deps/$(NSSM_LINK).zip))
		cd deps && wget $(NSSM_LINK)
	endif

clean:
	rm -rf deps/*
	rm -rf build/*
	rm -rf tmp/*

all: clean $(BIN)
