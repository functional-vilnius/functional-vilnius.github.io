GEN_TARGET_DIR=_site
SITE_GIT_DIR=$(GEN_TARGET_DIR).git
CNAME=CNAME
REMOTE=github.com/functional-vilnius/functional-vilnius.github.io

.PHONY: build commit upload

build:
	cabal run rebuild

$(GEN_TARGET_DIR): build

## Used by TravisCI

$(SITE_GIT_DIR):
	git fetch origin master:master
	git clone --single-branch -b master . $@

commit: | $(SITE_GIT_DIR) $(GEN_TARGET_DIR) $(CNAME)
	cp -r $(GEN_TARGET_DIR)/* $(SITE_GIT_DIR)
	cp $(CNAME) $(SITE_GIT_DIR)
	cd $(SITE_GIT_DIR) && \
		git add -A && \
		git diff --cached --quiet --exit-code || ( \
		git commit \
			-m "Build $$(TZ='Europe/Vilnius' date --rfc-3339=seconds)" && \
		git push ../ master:master) # avoid diverging

upload: | $(SITE_GIT_DIR)
	@test ${GH_TOKEN} || (echo "Error: Github Token missing!" && exit 1)
	test ${REMOTE}
	cd $(SITE_GIT_DIR) && \
		git push "https://${GH_TOKEN}@${REMOTE}" master:master
