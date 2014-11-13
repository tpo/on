#!/usr/bin/make -s

TEMPFILE:= $(shell mktemp)

create_readme: 
	$(shell cat README.md | awk '{ print; }; /on --help/ { exit; }' > ${TEMPFILE} )
	$(shell ./on --help | sed 's/^/    /' >> ${TEMPFILE} )
	@mv ${TEMPFILE} README.md
	@echo recreated README.md

.PHONY: create_readme

