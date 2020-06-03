build-docker:
	docker build . -t remote-psych:1.0
	docker rm -f remote-psych || true
	docker run --cpus 4 --cpu-shares 1024 --name remote-psych -d -v $(PWD):/app:rw remote-psych:1.0