CMDNAME := mm

.DEFAULT_GOAL := help

.PHONY: all help install update

all:

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "target:"
	@echo " - install:   Install memoru.sh as a $(CMDNAME) command."
	@echo " - update:    After git pull, execute the install command."
	@echo ""

install:
	curl -sSO https://raw.githubusercontent.com/humangas/fileopener/master/fileopener.sh
	chmod +x fileopener.sh
	rm -rf /usr/local/bin/$(CMDNAME)
	ln -s $(PWD)/memoru.sh /usr/local/bin/$(CMDNAME)
	chmod +x /usr/local/bin/$(CMDNAME)

update:
	git pull origin master
	@make install
