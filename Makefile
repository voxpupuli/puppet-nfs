ifneq ($(origin PUPPET_VERSION), undefined)
	puppet_version := ${PUPPET_VERSION}
else
	puppet_version := 5.0
endif

ifneq ($(origin STRICT_VARIABLES), undefined)
	export strict_variables := ${STRICT_VARIABLES}
else
	export strict_variables := yes
endif

ifneq ($(origin RVM), undefined)
	rvm := ${RVM}
else
	rvm := 2.4.1
endif

DOCKER_CMD := docker run -it --rm -v $$(pwd):/puppet derdanne/rvm:$(rvm) /bin/bash -l -c
PREPARE := rm -f .Gemfile.lock && $(DOCKER_CMD) "PUPPET_VERSION=$(puppet_version) bundle update --quiet puppet && PUPPET_VERSION=$(puppet_version) bundle install --quiet --without system_tests development --path=vendor/bundle"
VARIABLES := echo "PUPPET_VERSION=$(puppet_version), STRICT_VARIABLES=$(strict_variables), RVM=$(rvm)"

build:
	@cd spec/local-testing && \
	@docker build --squash --build-arg RUBY_VERSION=$(rvm) -t derdanne/rvm:$(rvm) .

pull:
	@docker pull derdanne/rvm:$(rvm)

install-gems:
	@$(VARIABLES)
	@$(PREPARE)

test-metadata-lint:
	@$(VARIABLES)
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$(puppet_version) bundle exec rake metadata_lint"

test-lint:
	@$(VARIABLES)
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$(puppet_version) bundle exec rake lint"

test-syntax:
	@$(VARIABLES)
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$(puppet_version) bundle exec rake syntax"

test-rspec:
	@$(VARIABLES)
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$(puppet_version) STRICT_VARIABLES=$(strict_variables) bundle exec rake spec"

test-rubocop:
	@$(VARIABLES)
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$(puppet_version) bundle exec rake rubocop"

test-all:
	@$(VARIABLES)
	@$(PREPARE)
	@$(DOCKER_CMD) "PUPPET_VERSION=$(puppet_version) STRICT_VARIABLES=$(strict_variables) bundle exec rake test"
	@$(DOCKER_CMD) "PUPPET_VERSION=$(puppet_version) bundle exec rake rubocop"

