ifneq ($(origin PUPPET_VERSION), undefined)
	puppet_version := ${PUPPET_VERSION}
else
	puppet_version := 7.20.0
endif

ifneq ($(origin STRICT_VARIABLES), undefined)
	export strict_variables := ${STRICT_VARIABLES}
else
	export strict_variables := yes
endif

ifneq ($(origin RVM), undefined)
	rvm := ${RVM}
else
	rvm := 3.1.3
endif

export rvm_beaker := 2.6.9

ifneq ($(origin BEAKER_set), undefined)
	beaker_set := ${BEAKER_set}
else
	beaker_set := ubuntu-22.04
endif

ifneq ($(origin PUPPET_collection), undefined)
	puppet_collection := ${PUPPET_collection}
else
	puppet_collection := puppet7
endif

DOCKER_CMD := docker run -it --rm -v $$(pwd):/puppet/module derdanne/rvm:$(rvm) /bin/bash -l -c
PREPARE := $(DOCKER_CMD) "PUPPET_VERSION=$(puppet_version)" bundle config set --local without 'system_tests development' path 'vendor/bundle' && rm -f Gemfile.lock && $(DOCKER_CMD) "PUPPET_VERSION=$(puppet_version) bundle install --quiet"

DOCKER_CMD_BEAKER := docker run --net host --privileged -it --rm -v $$(pwd):/puppet/module -v /var/run/docker.sock:/var/run/docker.sock derdanne/rvm:$(rvm_beaker) /bin/bash -l -c
PREPARE_BEAKER := rm -f Gemfile.lock && $(DOCKER_CMD_BEAKER) "bundle config set --local without 'system_tests development path 'vendor/bundle'' && bundle install --quiet"

VARIABLES := echo "PUPPET_VERSION=$(puppet_version), STRICT_VARIABLES=$(strict_variables), RVM=$(rvm), RVM_BEAKER=$(rvm_beaker)"

build:
	@cd spec/local-testing && docker build --squash --build-arg RUBY_VERSION=$(rvm) -t derdanne/rvm:$(rvm) .

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

test-beaker:
	@$(VARIABLES)
	@$(PREPARE_BEAKER)
	@$(DOCKER_CMD_BEAKER) "DOCKER_IN_DOCKER=true BEAKER_PUPPET_COLLECTION=$(puppet_collection) PUPPET_INSTALL_TYPE=agent BEAKER_debug=true BEAKER_set=$(beaker_set) BEAKER_destroy=onpass bundle exec rspec spec/acceptance"

pkg-build:
	@pdk build --force
