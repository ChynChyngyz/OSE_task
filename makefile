prep:
	sudo apt-get install pipx

install:
	pipx install flask
	pipx install requests
	pipx install numpy

clean:
	find . -name "*.tmp" -delete

help:
	@echo "Available targets:"
	@grep "^[a-zA-Z]" Makefile | awk -F':' '{print $1}'