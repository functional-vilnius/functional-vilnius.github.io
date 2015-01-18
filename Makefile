GEN_TARGET_DIR=_site
SUBMODULE_DIR=$(GEN_TARGET_DIR).git
CNAME=CNAME
REMOTE=github.com/functional-vilnius/functional-vilnius.github.io

.PHONY: build commit upload $(SUBMODULE_DIR)

build:
	cabal run rebuild

$(GEN_TARGET_DIR): build

## Used by TravisCI

$(SUBMODULE_DIR):
	git submodule update --init --remote
	git submodule foreach git checkout master

commit: $(SUBMODULE_DIR) | $(GEN_TARGET_DIR) $(CNAME)
	cp -r $(GEN_TARGET_DIR)/* $(SUBMODULE_DIR)
	cp $(CNAME) $(SUBMODULE_DIR)
	cd $(SUBMODULE_DIR) && \
		git add -A && \
		git commit \
			--allow-empty \
			-m "Build $$(TZ='Europe/Vilnius' date --rfc-3339=seconds)" && \
		git push ../ master:master # avoid diverging

upload: | $(SUBMODULE_DIR)
	@test ${GH_TOKEN} || (echo "Error: Github Token missing!" && exit 1)
	test ${REMOTE}
	cd $(SUBMODULE_DIR) && \
		git push "https://${GH_TOKEN}@${REMOTE}" master:master
