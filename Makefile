SHELL := /bin/bash

.PHONY: $(SERVICES) logs clean tests build

FORCE: ;  ## always run targets with this keyword


## NOTE: Add this to your .bashrc to enable make target tab completion
##    complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make
## Reference: https://stackoverflow.com/a/38415982

help: ## This info
	@echo '_________________'
	@echo '| Make targets: |'
	@echo '-----------------'
	@echo
	@cat Makefile | grep -E '^[a-zA-Z\/_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo

clean:  ## Remove untracked files except for .env file
	git clean -fxd --exclude .env

start:  ## Deploy instance to AWS
	pipenv run ansible-playbook -i hosts start.yml

stop:  ## Deploy instance to AWS
	pipenv run ansible-playbook -i hosts --extra-vars "ec2_instance_state=stopped" stop.yml

terminate:  ## Deploy instance to AWS
	pipenv run ansible-playbook -i hosts --extra-vars "ec2_instance_state=absent" stop.yml
