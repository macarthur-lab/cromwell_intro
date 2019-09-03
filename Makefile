TAG = weisburd/feature-counts:latest

all: build push

build:
	docker build -t $(TAG) .

push:
	docker push $(TAG)
