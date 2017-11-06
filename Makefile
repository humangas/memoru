NOTE_CMDNAME := note
NOTE_INSTALLPATH := ~/bin
FGO_CMDNAME := fgo 
FGO_INSTALLPATH := ~/bin

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
	curl -sSO https://raw.githubusercontent.com/humangas/fgopen/master/fgopen.sh
	rm -rf $(FGO_INSTALLPATH)/$(FGO_CMDNAME)
	cp $(PWD)/fgopen.sh $(FGO_INSTALLPATH)/$(FGO_CMDNAME)
	chmod +x $(FGO_INSTALLPATH)/$(FGO_CMDNAME)
	rm -rf $(NOTE_INSTALLPATH)/$(NOTE_CMDNAME)
	cp $(PWD)/note.sh $(NOTE_INSTALLPATH)/$(NOTE_CMDNAME)
	chmod +x $(NOTE_INSTALLPATH)/$(NOTE_CMDNAME)
	@echo ""
	@echo "Install Completion. Usage: $(NOTE_CMDNAME) --help"

update:
	git pull origin master
	@make install
