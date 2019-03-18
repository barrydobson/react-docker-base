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

dev: ## Run in local development mode
	@echo "Starting development server..."
	@docker-compose build dev
	@docker-compose up dev

test: ## Run unit testing
	@echo "Running unit tests..."
	@docker-compose build test
	@docker-compose run --rm test

prod: ## Run production build
	@echo "Running production build..."
	@docker-compose build prod
	@docker-compose run --rm --service-ports -e CLIENT_ENVIRONMENT=$(ENV) prod