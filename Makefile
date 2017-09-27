CONFIG = config-minimo.toml

all:
	hugo version
	hugo -v --config $(CONFIG) --i18n-warnings

dev:
	hugo server --config $(CONFIG) --buildDrafts --buildFuture --i18n-warnings

