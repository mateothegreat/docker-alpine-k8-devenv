NAME	= appsoa/docker-alpine-k8-devenv
ALIAS	= k8-devenv
VERSION	= 1.0.0

.PHONY:	all build test tag_latest release

all:	clean build

build:

	@echo "Building an image with the current tag $(NAME):$(VERSION).."

	docker build 	--rm 	\
					--tag $(NAME):$(VERSION) \
					.

run:

	docker run 	--rm -it							\
				-m "300M" --memory-swap "1G"		\
				--name $(ALIAS)						\
				--volume ~/.kube:/workspace/.kube	\
				$(NAME):$(VERSION) /bin/bash

test:

	docker run 	--rm -it							\
				-m "300M" --memory-swap "1G"		\
				--volume ~/.kube:/workspace/.kube	\
				$(NAME):$(VERSION) echo "kubectl version:" && kubectl version && echo "helm version:" && helm version

tag_latest:

	docker tag $(NAME):$(VERSION) $(NAME):latest

release:

	docker push $(NAME)
