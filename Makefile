TESTS_INIT=spec/minimal_init.lua
TESTS_DIR=spec/

.PHONY: test

test:
	@nvim \
		--headless \
		--noplugin \
		-n \
		-u ${TESTS_INIT} \
		-c "PlenaryBustedDirectory ${TESTS_DIR} { minimal_init = '${TESTS_INIT}' }"
