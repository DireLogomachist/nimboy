build:
	nim js src/web.nim

zip:
	zip -r dist/nimboy.zip index.html *.js

all: build zip
