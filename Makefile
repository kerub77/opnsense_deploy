# Cloud SPC
SPC_DEFAULT_PROFILE ?= default
SPC_DEFAULT_REGION  ?= region1

# TERRAFORM INSTALL
version  ?= "0.12.24"
os       ?= $(shell uname|tr A-Z a-z)
ifeq ($(shell uname -m),x86_64)
  arch   ?= "amd64"
endif
ifeq ($(shell uname -m),i686)
  arch   ?= "386"
endif
ifeq ($(shell uname -m),aarch64)
  arch   ?= "arm"
endif

ifndef terraform
  install ?= "true"
endif
ifeq ("$(upgrade)", "true")
  install ?= "true"
endif

distro := $(shell grep "^NAME=" /etc/os-release | cut -d "=" -f 2 | cut -d " " -f 1 | tr '[:upper:]' '[:lower:]')

# Exectutable
TERRAFORM_PATH := terraform
TERRARUNNER    := cd $(TERRAFORM_PATH) && terraform

# Project Info
CLIENT  := DXC
PROJECT := SKEL
VERSION := 0.1

.PHONY: check
check:
	@terraform --version
	@ansible --version

.PHONY: install
install: ## Install terraform and dependencies
ifeq ($(install),"true")
	@curl -s "https://releases.hashicorp.com/terraform/$(version)/terraform_$(version)_$(os)_$(arch).zip" -o /tmp/terraform.zip
	@sudo unzip -qo -d /usr/bin /tmp/terraform.zip && /bin/rm /tmp/terraform.zip
ifeq ($(distro),"centos")
	@sudo yum install -y epel-release
	@sudo yum install -y ansible graphviz
else
ifeq ($(distro),"ubuntu")
	@sudo apt-get update
	@sudo apt-get install software-properties-common
	@sudo apt-add-repository ppa:ansible/ansible -y
	@sudo apt-get update
	@sudo apt-get install ansible graphviz -y
endif
endif
endif
	@[ -d /etc/bash_completion.d ] && sudo curl -o /etc/bash_completion.d/terraform https://raw.githubusercontent.com/Bash-it/bash-it/master/completion/available/terraform.completion.bash
	$(MAKE) check

.PHONY: init
init: ## Init terraform and create ansible user keys
	@$(TERRARUNNER) init
	@mkdir -p .ssh
	@[ -f .ssh/id_ed25519 ] || ssh-keygen -t ed25519 -a 100 -q -N "" -C "ansible@cloudspc" -f .ssh/id_ed25519 -P ""

.PHONY: plan
plan:
	@$(TERRARUNNER) plan

.PHONY: apply
apply:
	@$(TERRARUNNER) apply

.PHONY: destroy
destroy:
	@$(TERRARUNNER) destroy

.PHONY: update
update:
	@$(TERRARUNNER) init --upgrade

.PHONY: graph
graph:
	@$(TERRARUNNER) graph -draw-cycles -module-depth=-1 | dot -Tsvg > ../extras/project.svg
