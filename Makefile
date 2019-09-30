
.DEFAULT_GOAL := help
help: ## Show this help message
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-25s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help

restart: ## Restart the server
restart: stop start
.PHONY: restart

start: ## Start the server
	bundle exec passenger start --environment=production --daemonize --address 127.0.0.1 --port 4000
.PHONY: start

stop: ## Stop the server
	bundle exec passenger stop --port 4000
.PHONY: stop

