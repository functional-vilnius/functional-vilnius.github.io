.PHONY: build

GEN_TARGET_DIR=_site
SUBMODULE_DIR=$(GEN_TARGET_DIR).git
CNAME=CNAME
REMOTE=github.com/functional-vilnius/functional-vilnius.github.io

build:
	cabal run rebuild

$(GEN_TARGET_DIR): build

$(SUBMODULE_DIR):
	git submodule update --init

## Used by TravisCI

commit: | $(GEN_TARGET_DIR) $(SUBMODULE_DIR) $(CNAME)
	cp -r $(GEN_TARGET_DIR)/* $(SUBMODULE_DIR)
	cp $(CNAME) $(SUBMODULE_DIR)
	cd $(SUBMODULE_DIR) && \
		git add -A && \
		git commit \
			--allow-empty \
			-m "Build $$(date '+%m/%d/%y %H:%M')" && \
		git push origin master:master

upload: | $(SUBMODULE_DIR)
	test ${GH_TOKEN}
	test ${REMOTE}
	cd $(SUBMODULE_DIR) && \
		git push "https://${GH_TOKEN}@${REMOTE}" master:master | grep -v http
