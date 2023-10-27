SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

IMAGE_NAME:=dust-test

.PHONY: all
all: build

.PHONY: build
build:
> docker build -t $(IMAGE_NAME) -f Dockerfile --target tester .

.PHONY: clean
clean:
> docker rmi $(IMAGE_NAME)

.PHONY: run
run: build
> docker run --rm --init --read-only --mount type=tmpfs,destination=/tmp $(IMAGE_NAME)

.PHONY: shell
shell: build
> docker run --rm -i -t --init --read-only --mount type=tmpfs,destination=/tmp --entrypoint "" $(IMAGE_NAME) /bin/sh
