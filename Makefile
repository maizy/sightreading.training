
.PHONY: lint_js

lint_js:
	node_modules/.bin/eslint $$(git ls-files | grep \.es6$$ | grep -v spec)
