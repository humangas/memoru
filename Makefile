.DEFAULT_GOAL := help

all:

help:
	@echo "TODO write.."

install:
	rm -rf /usr/local/bin/memoru
	ln -s $(PWD)/memoru.sh /usr/local/bin/memoru
	chmod +x /usr/local/bin/memoru

# TODO:
# - tplも移動する
# - デフォルトパス変更するmemoruに
# - envを別にして、make install時に環境変数セットして、それのディレクトリに↑をおいたりする
# - updateに、git pullさせとく　

.PHONY: all help install
