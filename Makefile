ifneq ($(origin PUPPET_VERSION), undefined)
	export PUPPET_VERSION := ${PUPPET_VERSION}
else
	export PUPPET_VERSION := 5.0
endif

ifneq ($(origin STRICT_VARIABLES), undefined)
	export STRICT_VARIABLES := ${STRICT_VARIABLES}
else
	export STRICT_VARIABLES := yes
endif

ifneq ($(origin RVM), undefined)
	export RVM := ${RVM}
else
	export RVM := 2.4.1
endif

build:
	cd spec/local-testing && \
	docker build --build-arg RUBY_VERSION=$${RVM} -t derdanne/rvm:$${RVM} .

pull:
	docker pull derdanne/rvm:$${RVM}

install-gems:
	docker run -it --rm -v $$(pwd):/puppet derdanne/rvm:$${RVM} /bin/bash -l -c "bundle install --without system_tests development --path=vendor/bundle"

test-metadata-lint:
	docker run -it --rm -v $$(pwd):/puppet derdanne/rvm:$${RVM} /bin/bash -l -c "bundle exec rake metadata_lint"

test-lint:
	docker run -it --rm -v $$(pwd):/puppet derdanne/rvm:$${RVM} /bin/bash -l -c "bundle exec rake lint"

test-syntax:
	docker run -it --rm -v $$(pwd):/puppet derdanne/rvm:$${RVM} /bin/bash -l -c "bundle exec rake syntax"

test-rspec:
	docker run -it --rm -v $$(pwd):/puppet derdanne/rvm:$${RVM} /bin/bash -l -c "PUPPET_VERSION=$${PUPPET_VERSION} bundle update puppet && PUPPET_VERSION=$${PUPPET_VERSION} STRICT_VARIABLES=$${STRICT_VARIABLES} bundle exec rake spec"

test-rubocop:
	docker run -it --rm -v $$(pwd):/puppet derdanne/rvm:$${RVM} /bin/bash -l -c "PUPPET_VERSION=$${PUPPET_VERSION} bundle update puppet && PUPPET_VERSION=$${PUPPET_VERSION} bundle exec rake rubocop"

test-all:
	docker run -it --rm -v $$(pwd):/puppet derdanne/rvm:$${RVM} /bin/bash -l -c "PUPPET_VERSION=$${PUPPET_VERSION} bundle update puppet && PUPPET_VERSION=$${PUPPET_VERSION} STRICT_VARIABLES=$${STRICT_VARIABLES} bundle exec rake test"
	docker run -it --rm -v $$(pwd):/puppet derdanne/rvm:$${RVM} /bin/bash -l -c "PUPPET_VERSION=$${PUPPET_VERSION} bundle update puppet && PUPPET_VERSION=$${PUPPET_VERSION} bundle exec rake rubocop"


