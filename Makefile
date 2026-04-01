.PHONY: help build build-ucsd build-dineshb-ucsd check-source deploy deploy-build deploy-dry-run deploy-preview sync-wcsng-catalog ensure-dineshb-ucsd-dir deploy-dineshb-ucsd deploy-dineshb-ucsd-dry-run

REMOTE ?= dineshb@login.eng.ucsd.edu
REMOTE_DIR ?= /home/dineshb/public_html
SOURCE_DIR ?= _site
UCSD_SOURCE_DIR ?= _site_ucsd
DOMAIN_SOURCE_DIR ?= _site_dineshb_ucsd
DOMAIN_REMOTE ?= dineshbweb@mywebsite.eng.ucsd.edu
DOMAIN_REMOTE_DIR ?= htdocs-next
PREVIEW_DIR ?= /tmp/academic-preview/_site
RSYNC ?= rsync
RSYNC_FLAGS ?= -avz --exclude=.DS_Store
SSH_KEY ?= $(HOME)/.ssh/id_ed25519
SSH_OPTS ?= -i $(SSH_KEY) -o IdentitiesOnly=yes
RSYNC_SSH ?= ssh $(SSH_OPTS)
RUBY_BIN ?= /opt/homebrew/opt/ruby/bin
RUBY_COMPAT ?= $(CURDIR)/tools/ruby4_compat.rb
BUNDLE ?= PATH=$(RUBY_BIN):$$PATH RUBYOPT="-r$(RUBY_COMPAT)" $(RUBY_BIN)/bundle
JEKYLL ?= $(BUNDLE) exec jekyll
JEKYLL_LOCAL_CONFIG ?= _config.yml,_config.dev.yml

help:
	@echo "Targets:"
	@echo "  make deploy            Sync \`$(SOURCE_DIR)\` to $(REMOTE):$(REMOTE_DIR)"
	@echo "  make deploy-dry-run    Show the rsync changes without copying"
	@echo "  make build             Run a local-safe Jekyll build into _site"
	@echo "  make build-ucsd        Run a UCSD-targeted build into $(UCSD_SOURCE_DIR)"
	@echo "  make build-dineshb-ucsd Build for https://dineshb.ucsd.edu into $(DOMAIN_SOURCE_DIR)"
	@echo "  make sync-wcsng-catalog Generate publication/resource tags and copied cover images from ../ucsdwcsng.github.io"
	@echo "  make deploy-build      Run a UCSD-targeted build, then sync it"
	@echo "  make deploy-dineshb-ucsd Build for dineshb.ucsd.edu and sync to $(DOMAIN_REMOTE):$(DOMAIN_REMOTE_DIR)"
	@echo "  make deploy-dineshb-ucsd-dry-run Show the rsync changes for the staged dineshb.ucsd.edu deploy"
	@echo "  make deploy-preview    Disabled for UCSD deploys; use deploy-build instead"
	@echo "  using SSH key          $(SSH_KEY)"
	@echo "  using Ruby             $(RUBY_BIN)/ruby"
	@echo "  using Ruby compat shim $(RUBY_COMPAT)"
	@echo ""
	@echo "Override defaults if needed, for example:"
	@echo "  make deploy SOURCE_DIR=/tmp/academic-preview/_site"

build:
	@$(JEKYLL) build --config "$(JEKYLL_LOCAL_CONFIG)" --destination "_site" || { \
		echo ""; \
		echo "Jekyll build failed."; \
		echo "Check the Ruby/Bundler/Jekyll output above for the current failure."; \
		echo "If you just need to publish the last known-good preview, use 'make deploy-preview'."; \
		exit 1; \
	}

build-ucsd:
	@$(JEKYLL) build --config "_config.yml,_config.ucsd.yml" --destination "$(UCSD_SOURCE_DIR)" || { \
		echo ""; \
		echo "UCSD Jekyll build failed."; \
		echo "Check the Ruby/Bundler/Jekyll output above for the current failure."; \
		exit 1; \
	}

build-dineshb-ucsd:
	@$(JEKYLL) build --config "_config.yml,_config.dineshb-ucsd.yml" --destination "$(DOMAIN_SOURCE_DIR)" || { \
		echo ""; \
		echo "dineshb.ucsd.edu Jekyll build failed."; \
		echo "Check the Ruby/Bundler/Jekyll output above for the current failure."; \
		exit 1; \
	}

sync-wcsng-catalog:
	ruby tools/sync_wcsng_catalog.rb

check-source:
	@test -d "$(SOURCE_DIR)" || (echo "Missing source directory: $(SOURCE_DIR)" && exit 1)

deploy: check-source
	$(RSYNC) $(RSYNC_FLAGS) -e "$(RSYNC_SSH)" "$(SOURCE_DIR)/" "$(REMOTE):$(REMOTE_DIR)/"

deploy-build: build-ucsd
	$(MAKE) deploy SOURCE_DIR="$(UCSD_SOURCE_DIR)"

ensure-dineshb-ucsd-dir:
	ssh $(SSH_OPTS) $(DOMAIN_REMOTE) 'mkdir -p $(DOMAIN_REMOTE_DIR)'

deploy-dineshb-ucsd: build-dineshb-ucsd ensure-dineshb-ucsd-dir
	$(RSYNC) $(RSYNC_FLAGS) -e "$(RSYNC_SSH)" "$(DOMAIN_SOURCE_DIR)/" "$(DOMAIN_REMOTE):$(DOMAIN_REMOTE_DIR)/"

deploy-dineshb-ucsd-dry-run: build-dineshb-ucsd ensure-dineshb-ucsd-dir
	$(RSYNC) $(RSYNC_FLAGS) --dry-run -e "$(RSYNC_SSH)" "$(DOMAIN_SOURCE_DIR)/" "$(DOMAIN_REMOTE):$(DOMAIN_REMOTE_DIR)/"

deploy-dry-run: check-source
	$(RSYNC) $(RSYNC_FLAGS) --dry-run -e "$(RSYNC_SSH)" "$(SOURCE_DIR)/" "$(REMOTE):$(REMOTE_DIR)/"

deploy-preview:
	@echo "deploy-preview is disabled for UCSD deployments because preview output contains local-only URLs."
	@echo "Use 'make deploy-build' instead."
	@exit 1
