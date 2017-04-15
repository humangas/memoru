MM_CMDNAME := mm
MM_INSTALLPATH := /usr/local/bin
FO_CMDNAME := fo 
FO_INSTALLPATH := /usr/local/bin

.DEFAULT_GOAL := help

.PHONY: all help install update

all:

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "target:"
	@echo " - install:   Install memoru.sh as a $(MM_CMDNAME) command."
	@echo " - update:    After git pull, execute the install command."
	@echo ""

install:
	curl -sSO https://raw.githubusercontent.com/humangas/fileopener/master/fileopener.sh
	rm -rf $(FO_INSTALLPATH)/$(FO_CMDNAME)
	cp $(PWD)/fileopener.sh $(FO_INSTALLPATH)/$(FO_CMDNAME)
	chmod +x $(FO_INSTALLPATH)/$(FO_CMDNAME)
	rm -rf $(MM_INSTALLPATH)/$(MM_CMDNAME)
	cp $(PWD)/memoru.sh $(MM_INSTALLPATH)/$(MM_CMDNAME)
	chmod +x $(MM_INSTALLPATH)/$(MM_CMDNAME)
	@echo ""
	@echo "Install Completion. Usage: $(MM_CMDNAME) --help"

update:
	git pull origin master
	@make install
