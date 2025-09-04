build:
	nim js src/main.nim

zip:
	zip -r dist/nimboy.zip index.html *.js

all: build zip
