.PHONY: all dev init bash exec upgrade update assets latest default build up clean open open-db setup help

PHP_SERVICE     ?= php
APP_TESTER_SERVICE  ?= app-test-php
PROJECT_TESTER_SERVICE  ?= project-test-php
BROWSER_SERVICE ?= chrome
COMPOSE_FILE_QA ?= ../docker-compose.yml:./docker-compose.test.yml:./docker-compose.qa.yml
ROOT_PATH       ?= project

CODECEPTION_GROUP ?= mandatory
CODECEPTION_ENV   ?= chrome

# Define the docker-compose binary via ENV variable
DOCKER_COMPOSE  ?= docker-compose
# Default for Linux & Docker for Mac, set ENV variable when running i.e. docker-machine under macOS
DOCKER_HOST     ?= localhost

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Darwin)
	OPEN_CMD        ?= open
else
	OPEN_CMD        ?= xdg-open
endif

ifdef DOCKER_HOST
	DOCKER_HOST_IP  ?= $(shell echo $(DOCKER_HOST) | sed 's/tcp:\/\///' | sed 's/:[0-9.]*//')
else
	DOCKER_HOST_IP  ?= 127.0.0.1
endif


# Targets
# -------

default: help

all:    ##@base shorthand for 'build init up setup open'
all: init build install up setup browser
all:
	#
	# make all
	# Done.


build: ##@base build images in stack
	#
	# Building images from docker-compose definitions
	#
	$(DOCKER_COMPOSE) build --pull

up: ##@base start stack
	#
	# Starting application stack
	#
	$(DOCKER_COMPOSE) up -d

clean: ##@base remove all containers in stack
	#
	# Cleaning Docker environment
	#
	$(DOCKER_COMPOSE) kill
	$(DOCKER_COMPOSE) rm -fv
	$(DOCKER_COMPOSE) down --remove-orphans


logs: ##@base show logs
	#
	# Running application setup command (database, user)
	#
	$(DOCKER_COMPOSE) logs -f --tail 100 | cat -v


version: ##@base write current version string from git
	$(shell echo $(shell git describe --long --tags --dirty --always) > ./project/version)
	@echo $(shell cat ./project/version)


upgrade: ##@base update application package, pull, rebuild
	#
	# Running package upgrade in container
	# Note: If you have performance with this operation issues, please check the documentation under http://phd.dmstr.io/docs
	#
	$(DOCKER_COMPOSE) run --rm php composer update -v

dist-upgrade: ##@development update application package, pull, rebuild
	$(DOCKER_COMPOSE) build --pull --build-arg BUILD_NO_INSTALL=1
	$(MAKE) upgrade
	$(MAKE) build

install: ##@development install PHP packages
	$(DOCKER_COMPOSE) run --rm php composer install

bash:	 ##@development execute application bash in running container
	#
	# Starting application bash
	#
	$(DOCKER_COMPOSE) exec php bash

cli:	 ##@development run application cli in one-off container
	#
	# Starting application CLI container
	#
	$(DOCKER_COMPOSE) run --rm --workdir=/app/src -e PHP_USER_ID=0 $(PHP_SERVICE) bash

assets:	 ##@development open application development bash
	#
	# Building asset bundles
	#
	$(DOCKER_COMPOSE) run --rm -e APP_ASSET_USE_BUNDLED=0 $(PHP_SERVICE) yii asset/compress config/assets.php web/bundles/config.php


init:    ##@development prepares development environment (local config files and folders)
init:
	#
	# Running composer installation in development environment
	# This may take a while on your first install...
	#
	cp -n .env-dist .env &2>/dev/null
	touch $(ROOT_PATH)/config/local.env
	test -f ./docker-compose.local.yml || head -n 1 ./docker-compose.yml > ./docker-compose.local.yml

setup: ##@development run application setup
	#
	# Running application setup command (database, user)
	#
	$(DOCKER_COMPOSE) run --rm $(PHP_SERVICE) yii app/setup

open: browser ##@development alias for: browser
browser: ##@development open application web service in browser
	#
	# Opening application on mapped web-service port
	#
	$(OPEN_CMD) http://$(DOCKER_HOST_IP):$(shell $(DOCKER_COMPOSE) port php 80 | sed 's/[0-9.]*://') &>/dev/null

open-db: ##@base open application database service in browser
	$(OPEN_CMD) mysql://root:secret@$(DOCKER_HOST_IP):$(shell $(DOCKER_COMPOSE) port db 3306 | sed 's/[0-9.]*://') &>/dev/null

open-mailcatcher: ##@base open mailcatcher service in browser
	$(OPEN_CMD) http://$(DOCKER_HOST_IP):$(shell $(DOCKER_COMPOSE) port mailcatcher 80 | sed 's/[0-9.]*://') &>/dev/null



test: version build install up
test: ##@test run tests
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test $(PROJECT_TESTER_SERVICE) yii app/setup
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test $(PROJECT_TESTER_SERVICE) codecept clean
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test $(PROJECT_TESTER_SERVICE) codecept run --env $(BROWSER_SERVICE) -g ${CODECEPTION_GROUP} --steps --html --xml= --tap --json

test-coverage: version build install up
test-coverage: ##@test run tests with code coverage
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test $(PROJECT_TESTER_SERVICE) yii app/setup
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test $(PROJECT_TESTER_SERVICE) codecept clean
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test $(PROJECT_TESTER_SERVICE) codecept run --env $(BROWSER_SERVICE) -g ${CODECEPTION_GROUP} --coverage-html --coverage-xml --html --xml

test-init: ##@test initialize test-environment
	mkdir -p _host-volumes/project-tests-log && chmod 777 _host-volumes/project-tests-log

test-bash:	 ##@test execute tester bash in running container
	#
	# Starting application bash
	#
	$(DOCKER_COMPOSE) run --rm $(PROJECT_TESTER_SERVICE)  bash

test-cli:	 ##@test run application test bash in one-off container
	#
	# Starting application bash
	#
	$(DOCKER_COMPOSE) run --rm -v $(PWD)/vendor-dev:/app/vendor $(PROJECT_TESTER_SERVICE) bash

test-open: test-browser ##@test alias for: test-browser
test-browser: ##@test open application project-test web service in browser
	#
	# Opening application on mapped web-service port
	#
	$(OPEN_CMD) http://$(DOCKER_HOST_IP):$(shell $(DOCKER_COMPOSE) port $(PROJECT_TESTER_SERVICE)  80 | sed 's/[0-9.]*://') &>/dev/null

test-selenium: ##@test open selenium container via VNC
	$(OPEN_CMD) vnc://$(DOCKER_HOST_IP):$(shell $(DOCKER_COMPOSE) port $(BROWSER_SERVICE) 5900 | sed 's/[0-9.]*://') &>/dev/null

test-report: ##@test open report/log folder
	$(OPEN_CMD) _host-volumes/project-tests-log &>/dev/null

app-test: version build install up
app-test: ##@test run tests
	$(DOCKER_COMPOSE) run --rm -w /app/tests -e YII_ENV=test $(APP_TESTER_SERVICE) mkdir -p _log/codeception
	$(DOCKER_COMPOSE) run --rm -w /app/tests -e YII_ENV=test $(APP_TESTER_SERVICE) sh -c 'codecept clean'
	$(DOCKER_COMPOSE) run --rm -w /app/tests -e YII_ENV=test $(APP_TESTER_SERVICE) sh -c 'codecept run  --env ${CODECEPTION_ENV} --steps -g ${CODECEPTION_GROUP} --html --xml'



fix-source:	 ##@development fix source-code linting errors
	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#
	# Fixing source-code lint errors with cs-fixer
	#
	$(DOCKER_COMPOSE) run --rm $(PROJECT_TESTER_SERVICE) php-cs-fixer fix --format=txt -v ../src

lint-source:	 ##@development run source-code linting
	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#
	# Liniting source-code with cs-fixer
	#
	$(DOCKER_COMPOSE) run --rm $(PROJECT_TESTER_SERVICE) php-cs-fixer fix --format=txt -v --dry-run ../src

lint-metrics:	 ##@development run source-code metrics
	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#
	# Fixing source-code lint errors with cs-fixer
	#
	docker run --rm -v "${PWD}:/app" --workdir=/app herloct/phpmetrics --report-html=tests/_log/lint/metrics --exclude=migrations,runtime src/
	docker run --rm -v "${PWD}:/project" jolicode/phaudit phpmd src html tests/phpmd/rulesets.xml --exclude src/migrations > tests/_log/lint/mess.html
	exit ${ERROR}

lint-composer: ##@development run composer linting
	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#
	# Liniting composer configuration
	#
	$(DOCKER_COMPOSE) run --rm $(PROJECT_TESTER_SERVICE) composer -d../ --no-ansi --no-check-publish validate

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#
	# Listing installed packages
	#
	$(DOCKER_COMPOSE) run --rm $(PROJECT_TESTER_SERVICE) sh -c 'composer -d../ --no-ansi show -f json | tee _log/packages-$(shell cat /app/src/version).json'

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#
	# Listing outdated packages
	#
	$(DOCKER_COMPOSE) run -T --rm $(PROJECT_TESTER_SERVICE) composer --no-ansi show -o -f json | grep -zo "\{.*\}" | tee tests/_log/composer-outdated-packages-$(shell cat ./project/version).json || ERROR=1; \
	exit ${ERROR}

lint-html:
	COMPOSE_FILE=$(COMPOSE_FILE_QA) $(DOCKER_COMPOSE) run --rm  validator http://web

lint-links:
	COMPOSE_FILE=$(COMPOSE_FILE_QA) $(DOCKER_COMPOSE) run --rm  linkchecker linkchecker http://web -F html/utf8/./tmp/tests/_log/check.html -f /tmp/tests/linkcheckerrc -r 3 -t 5

lint: version install lint-source lint-composer





# Help based on https://gist.github.com/prwhite/8168133 thanks to @nowox and @prwhite
# And add help text after each target name starting with '\#\#'
# A category can be added with @category

HELP_FUN = \
		%help; \
		while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([\w-]+)\s*:.*\#\#(?:@([\w-]+))?\s(.*)$$/ }; \
		print "\nusage: make [target ...]\n\n"; \
	for (keys %help) { \
		print "$$_:\n"; \
		for (@{$$help{$$_}}) { \
			$$sep = "." x (25 - length $$_->[0]); \
			print "  $$_->[0]$$sep$$_->[1]\n"; \
		} \
		print "\n"; }

help: ##@system show this help
	#
	# General targets
	#
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
