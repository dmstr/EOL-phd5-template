CODECEPTION_GROUP ?= mandatory

include ../Makefile.base

all: ##@test [TEST] shorthand for
	$(MAKE) init-tests version build
	$(MAKE) clean up setup

init-tests:
	mkdir -p _log/codeception && chmod -R 777 _log/codeception
	mkdir -p _log/lint && chmod -R 777 _log/lint
	mkdir -p ../_test-volumes/storage/fs-local && chmod -R 777 ../_test-volumes/storage/fs-local

version:
	$(shell echo $(shell git describe --long --tags --dirty --always) > ../src/version)
	@echo $(shell cat ../src/version)

bash: ##@development open application development bash
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test php bash

bash-xdebug: ##@development open application development bash with xdebug enabled
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test -e PHP_ENABLE_XDEBUG=1 php bash

run-tests: ##@test run tests
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test php sh -c 'codecept clean'
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test php sh -c 'chmod -R 777 /root/.composer && codecept run --steps -g ${CODECEPTION_GROUP} --html=_report.html --xml=junit.xml'

run-coverage: ##@test run tests
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test -e PHP_ENABLE_XDEBUG=1 php sh -c 'chmod -R 777 /root/.composer && codecept run -x optional --coverage-html --html=_report-coverage.html'


open-vnc: ##@test open application database service in browser
	$(OPEN_CMD) vnc://x:secret@$(DOCKER_HOST_IP):$(shell $(DOCKER_COMPOSE) port firefox 5900 | sed 's/[0-9.]*://')

open-mailcatcher: ##@test open mail testing service in browser
	$(OPEN_CMD) http://$(DOCKER_HOST_IP):$(shell $(DOCKER_COMPOSE) port mailcatcher 1080 | sed 's/[0-9.]*://')

open-report: ##@test open HTML reports
	$(OPEN_CMD) codeception/_output/_report.html

open-coverage: ##@test open HTML reports
	$(OPEN_CMD) codeception/_output/coverage/index.html

open-c3:
	$(OPEN_CMD) http://$(DOCKER_HOST_IP):$(shell $(DOCKER_COMPOSE) port web 80 | sed 's/[0-9.]*://')/c3/report/clear


lint-source:	 ##@development run source-code linting
	#
	# Liniting source-code with cs-fixer, phpmetrics & phpmd
	#
	docker-compose run --rm php php-cs-fixer fix --format=txt -v --dry-run ../src || export ERROR=1; \
	docker run --rm -v "${PWD}/..:/app" --workdir=/app herloct/phpmetrics --report-html=tests/_log/lint/metrics.html --exclude=migrations/,base/ src/ || ERROR=1; \
	docker run --rm -v "${PWD}/..:/project" jolicode/phaudit phpmd src html phpmd/rulesets.xml --exclude src/migrations > _log/lint/mess.html || ERROR=1; \
	exit ${ERROR}

lint-composer: ##@development run composer linting
	#
	# Liniting composer configuration
	#
	docker-compose run --rm php composer --no-ansi validate || ERROR=1; \
	docker-compose run --rm php composer --no-ansi show || ERROR=1; \
	docker-compose run --rm php composer --no-ansi show -o || ERROR=1; \
	exit ${ERROR}

lint: lint-source lint-composer