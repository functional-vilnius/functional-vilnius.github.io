.PHONY: build

GEN_TARGET_DIR=_site
SUBMODULE_DIR=$(GEN_TARGET_DIR).git
CNAME=CNAME

build:
	cabal run rebuild

$(GEN_TARGET_DIR): build

$(SUBMODULE_DIR):
	git submodule update --init

commit: $(GEN_TARGET_DIR) $(SUBMODULE_DIR) $(CNAME)
	cp -r $(GEN_TARGET_DIR)/* $(SUBMODULE_DIR)
	cp $(CNAME) $(SUBMODULE_DIR)
	cd $(SUBMODULE_DIR) && \
		git add -A && \
		git commit \
			-m "Build $$(date '+%m/%d/%y %H:%M')"

