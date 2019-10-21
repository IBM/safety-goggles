.PHONY: build clean precommit publish spec

VERSION:=$(shell cat VERSION)

build: precommit tag
	gem build *.gemspec
	gem install *.gem --ignore-dependencies

clean:
	rm *.gem

publish: build
	gem inabox *.gem
	make clean

precommit:
	-@gem install geminabox
	-rubocop -Da
	-bundle
	-bundle-audit check --update
	-pre-commit run --all-files

spec:
	bundle exec rspec

tag:
	git tag -f v$(VERSION)
