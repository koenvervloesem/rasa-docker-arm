.PHONY: check clean dev_requirements docker

check:
	./scripts/check_code.sh

clean:
	rm -r bazel

dev_requirements:
	./scripts/install_dev_requirements.sh

docker:
	./scripts/build_docker.sh
