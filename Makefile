CONFIG = config-minimo.toml

all:
	hugo version
	hugo -v --config $(CONFIG)

dev:
	hugo server --config $(CONFIG) --buildDrafts --buildFuture

