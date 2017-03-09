.PHONY: build clean precommit push spec

VERSION:=$(shell cat VERSION)

build: precommit tag
	gem build *.gemspec
	gem install *.gem --ignore-dependencies

clean:
	rm *.gem

push: build
	gem push *-$(VERSION).gem
	make clean

precommit:
	-@gem install geminabox
	-rubocop -Da
	-bundle
	-bundle-audit check --update

spec:
	bundle exec rspec

tag:
	git tag -f v$(VERSION)
