CODECEPTION_GROUP ?= mandatory
CODECEPTION_ENV   ?= chrome
TESTER_SERVICE    ?= tester
BROWSER_SERVICE   ?= chrome

include ../../Makefile.base

all: ##@test [TEST] shorthand for
	$(MAKE) init-tests version build install
	$(MAKE) clean up setup

init-tests: ##@development initialize test-environment
	cp -n .env-dist .env &2>/dev/null

install:
	$(DOCKER_COMPOSE) run -w /app --rm $(TESTER_SERVICE) composer install

version:
	$(shell echo $(shell git describe --long --tags --dirty --always) > ../version)
	@echo $(shell cat ../version)

bash: ##@development open application development bash
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test $(TESTER_SERVICE) bash

bash-xdebug: ##@development open application development bash with xdebug enabled
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test -e PHP_ENABLE_XDEBUG=1 $(TESTER_SERVICE) bash

run-tests: ##@test run tests
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test $(TESTER_SERVICE) sh -c 'codecept clean'
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test $(TESTER_SERVICE) sh -c 'codecept run --env ${CODECEPTION_ENV} --steps -g ${CODECEPTION_GROUP} --html --xml'

run-coverage: ##@test run tests
	$(DOCKER_COMPOSE) run --rm -e YII_ENV=test -e PHP_ENABLE_XDEBUG=1 $(TESTER_SERVICE) sh -c 'codecept run -x optional --coverage-html --html=_report-coverage.html'

run-tests-app: ##@test run tests
	$(DOCKER_COMPOSE) run --rm -w /app/tests -e YII_ENV=test $(TESTER_SERVICE) mkdir -p _log/codeception
	$(DOCKER_COMPOSE) run --rm -w /app/tests -e YII_ENV=test $(TESTER_SERVICE) sh -c 'codecept clean'
	$(DOCKER_COMPOSE) run --rm -w /app/tests -e YII_ENV=test $(TESTER_SERVICE) sh -c 'codecept run  --env ${CODECEPTION_ENV} --steps -g ${CODECEPTION_GROUP} --html --xml'


open-vnc: ##@test open application database service
	$(OPEN_CMD) vnc://$(DOCKER_HOST_IP):$(shell $(DOCKER_COMPOSE) port $(BROWSER_SERVICE) 5900 | sed 's/[0-9.]*://') &>/dev/null

open-report: ##@test open HTML reports
	$(OPEN_CMD) _log/codeception/report.html &>/dev/null

open-coverage: ##@test open HTML reports
	$(OPEN_CMD) _log/coverage/index.html &>/dev/null

open-c3:
	$(OPEN_CMD) http://$(DOCKER_HOST_IP):$(shell $(DOCKER_COMPOSE) port web 80 | sed 's/[0-9.]*://')/c3/report/clear &>/dev/null


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
