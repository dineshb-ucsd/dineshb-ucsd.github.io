.PHONY: help build build-ucsd check-source deploy deploy-build deploy-dry-run deploy-preview

REMOTE ?= dineshb@login.eng.ucsd.edu
REMOTE_DIR ?= /home/dineshb/public_html
SOURCE_DIR ?= _site
UCSD_SOURCE_DIR ?= _site_ucsd
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
JEKYLL_CONFIG ?= _config.yml

help:
	@echo "Targets:"
	@echo "  make deploy            Sync \`$(SOURCE_DIR)\` to $(REMOTE):$(REMOTE_DIR)"
	@echo "  make deploy-dry-run    Show the rsync changes without copying"
	@echo "  make build             Run a standard local Jekyll build into _site"
	@echo "  make build-ucsd        Run a UCSD-targeted build into $(UCSD_SOURCE_DIR)"
	@echo "  make deploy-build      Run a UCSD-targeted build, then sync it"
	@echo "  make deploy-preview    Disabled for UCSD deploys; use deploy-build instead"
	@echo "  using SSH key          $(SSH_KEY)"
	@echo "  using Ruby             $(RUBY_BIN)/ruby"
	@echo "  using Ruby compat shim $(RUBY_COMPAT)"
	@echo ""
	@echo "Override defaults if needed, for example:"
	@echo "  make deploy SOURCE_DIR=/tmp/academic-preview/_site"

build:
	@$(JEKYLL) build --config "$(JEKYLL_CONFIG)" --destination "_site" || { \
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

check-source:
	@test -d "$(SOURCE_DIR)" || (echo "Missing source directory: $(SOURCE_DIR)" && exit 1)

deploy: check-source
	$(RSYNC) $(RSYNC_FLAGS) -e "$(RSYNC_SSH)" "$(SOURCE_DIR)/" "$(REMOTE):$(REMOTE_DIR)/"

deploy-build: build-ucsd
	$(MAKE) deploy SOURCE_DIR="$(UCSD_SOURCE_DIR)"

deploy-dry-run: check-source
	$(RSYNC) $(RSYNC_FLAGS) --dry-run -e "$(RSYNC_SSH)" "$(SOURCE_DIR)/" "$(REMOTE):$(REMOTE_DIR)/"

deploy-preview:
	@echo "deploy-preview is disabled for UCSD deployments because preview output contains local-only URLs."
	@echo "Use 'make deploy-build' instead."
	@exit 1
