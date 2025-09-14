build:
	nim js -d:release src/main.nim

zip:
	zip -r dist/nimboy.zip index.html src/*.js src/assets

all: build zip
