# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

ENV ?= local

cra: ## Create React App "
	docker build -f cra.Dockerfile -t cra .
	docker run --rm --name cra-container -it -v ${PWD}:/usr/src cra /bin/sh -c "create-react-app react-app"	

run-local: ## Run the React App in local development mode
	@echo "Running App..."
	docker-compose -f docker-compose-local.yaml up --build 

run-ci: ## Run all tests as per CI
	@echo "Starting Tests..."
	docker-compose -f docker-compose-local.yaml run --rm --no-deps -e CI=true react-app npm test

build-prod: ## Make final build
	@echo "Making build..."
	docker build -t react-app-build -f production.Dockerfile .

run-prod: ## Run production container
	@echo "Running production container on http://localhost:3001/"
	docker run --rm -it -p 3001:80 -e ENVIRONMENT=$(ENV) react-app-build