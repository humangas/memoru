NOTE_CMDNAME := note
NOTE_INSTALLPATH := /usr/local/bin

.DEFAULT_GOAL := help

.PHONY: all help install update test

all:

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "target:"
	@echo " - install:   Install note.sh as a $(NOTE_CMDNAME) command."
	@echo " - update:    After git pull, execute the install command."
	@echo " - test:      Test note.sh with bats-core/bats-core"
	@echo ""

install:
	rm -rf $(NOTE_INSTALLPATH)/$(NOTE_CMDNAME)
	cp $(PWD)/note.sh $(NOTE_INSTALLPATH)/$(NOTE_CMDNAME)
	chmod +x $(NOTE_INSTALLPATH)/$(NOTE_CMDNAME)
	@echo ""
	@echo "Install Completion. Usage: $(NOTE_CMDNAME) --help"

update:
	git pull origin master
	@make install

test:
	bats test/note.bats
