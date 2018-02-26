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

DOCKER_CMD := docker run -it --rm -v $$(pwd):/puppet derdanne/rvm:$${RVM} /bin/bash -l -c
PREPARE := rm -f .Gemfile.lock && $(DOCKER_CMD) "PUPPET_VERSION=$${PUPPET_VERSION} bundle install --quiet --without system_tests development --path=vendor/bundle"

build:
	@cd spec/local-testing && \
	@docker build --squash --build-arg RUBY_VERSION=$${RVM} -t derdanne/rvm:$${RVM} .

pull:
	@docker pull derdanne/rvm:$${RVM}

install-gems:
	@$(PREPARE)

test-metadata-lint:
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$${PUPPET_VERSION} bundle exec rake metadata_lint"

test-lint:
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$${PUPPET_VERSION} bundle exec rake lint"

test-syntax:
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$${PUPPET_VERSION} bundle exec rake syntax"

test-rspec:
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$${PUPPET_VERSION} STRICT_VARIABLES=$${STRICT_VARIABLES} bundle exec rake spec"

test-rubocop:
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$${PUPPET_VERSION} bundle exec rake rubocop"

test-all:
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$${PUPPET_VERSION} STRICT_VARIABLES=$${STRICT_VARIABLES} bundle exec rake test"
	@$(DOCKER_CMD) "PUPPET_VERSION=$${PUPPET_VERSION} bundle exec rake rubocop"

