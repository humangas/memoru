NOTE_CMDNAME := note
NOTE_INSTALLPATH := ~/bin
FING_CMDNAME := fing 
FING_INSTALLPATH := ~/bin

.DEFAULT_GOAL := help

.PHONY: all help install update

all:

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "target:"
	@echo " - install:   Install note.sh as a $(NOTE_CMDNAME) command."
	@echo " - update:    After git pull, execute the install command."
	@echo ""

install:
	curl -sSO https://raw.githubusercontent.com/humangas/findgrep/master/findgrep.sh
	rm -rf $(FING_INSTALLPATH)/$(FING_CMDNAME)
	cp $(PWD)/findgrep.sh $(FING_INSTALLPATH)/$(FING_CMDNAME)
	chmod +x $(FING_INSTALLPATH)/$(FING_CMDNAME)
	rm -rf $(NOTE_INSTALLPATH)/$(NOTE_CMDNAME)
	cp $(PWD)/note.sh $(NOTE_INSTALLPATH)/$(NOTE_CMDNAME)
	chmod +x $(NOTE_INSTALLPATH)/$(NOTE_CMDNAME)
	@echo ""
	@echo "Install Completion. Usage: $(NOTE_CMDNAME) --help"

update:
	git pull origin master
	@make install
