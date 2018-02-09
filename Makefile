CONFIG = config-minimo.toml

all: ## Build whole site
	hugo version
	hugo -v --config $(CONFIG) --i18n-warnings

netlify: ## Build whole site for netlify
	hugo version
	hugo -v --config $(CONFIG) --i18n-warnings -b ${DEPLOY_PRIME_URL}

dev: ## For local development, rebuild site on change
	hugo server --config $(CONFIG) --buildDrafts --buildFuture --i18n-warnings

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-21s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
