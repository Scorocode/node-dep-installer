.DEFAULT_GOAL := container-push

NAME:=node-dep-installer
RELEASE:=1.0.0
REGISTRY:=scorocode
CONTAINER_IMAGE:=$(REGISTRY)/$(NAME):$(RELEASE)

.PHONY: clean
clean:
	@echo "Delete image"
	-docker rm -f `docker ps -a -q --filter=ancestor=$(CONTAINER_IMAGE)`
	-docker rmi -f `docker images -q $(CONTAINER_IMAGE)`

.PHONY: container-build
container-build: clean
	docker build --tag $(CONTAINER_IMAGE) --file Dockerfile .

.PHONY: container-push
container-push: container-build
	docker push $(CONTAINER_IMAGE)


.PHONY: test
test:
	$(eval _TMP_DIR := $(shell pwd)/tmp)
	@echo "test dir:" $(_TMP_DIR)
	@rm -rf $(_TMP_DIR)
	@mkdir -p -m 755 $(_TMP_DIR)

	# brefore test:
	docker run --user "$(shell id -u):$(shell id -g)" --rm -it -v "$(_TMP_DIR):/var/data/project" $(CONTAINER_IMAGE) npm init -y
	docker run --user "$(shell id -u):$(shell id -g)" --rm -it -v "$(_TMP_DIR):/var/data/project" $(CONTAINER_IMAGE) npm i -S express@4.16.4 google-protobuf@3.6.1 socket.io@2.1.1 tslib@1.9.3 typescript@3.1.6
	@rm -rf $(_TMP_DIR)/node_modules

	# start test
	docker run --user "$(shell id -u):$(shell id -g)" --rm -it -v "$(_TMP_DIR):/var/data/project" $(CONTAINER_IMAGE)

