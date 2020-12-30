serve: vendor/
	bundle exec jekyll serve --incremental

vendor/: Gemfile Gemfile.lock
	bundle install

