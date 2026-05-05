build:
	nim js -d:release src/main.nim

zip:
	zip -r dist/plummet.zip index.html src/*.js src/assets

all: build zip
