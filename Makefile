path := "./docker-compose/"

.PHONY: help

help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

clean: # Remove generated keys from directory
	rm -f $(path)keyfile $(path)*.key $(path)*.pem $(path)*.csr $(path)*.srl 

generate-keyfile: # (1) Generate keyfile for access control for replica sets (https://www.mongodb.com/docs/manual/tutorial/enforce-keyfile-access-control-in-existing-replica-set/#create-a-keyfile)
	openssl rand -base64 756 > $(path)keyfile
	chmod 400 $(path)keyfile

generate-self-signed-ca: # (2) Generate a self-signed CA certificate
	openssl req -new -x509 -days 365 -out $(path)ca.pem -keyout $(path)ca.key

generate-server-key: # (3) Generate a server key
	openssl genpkey -algorithm RSA -out $(path)server.key

generate-ca-signing-request: # (4) Generate a certificate signing request (CSR) for the server
	openssl req -new -key $(path)server.key -out $(path)server.csr

sign-server-csr-with-ca: generate-server-key generate-self-signed-ca generate-ca-signing-request # (5) Sign the server CSR with the CA certificate
	openssl x509 -req -in $(path)server.csr -CA $(path)ca.pem -CAkey $(path)ca.key -CAcreateserial -out $(path)server.pem -days 365

docker-stack-deploy: # Deploy docker swarm and stack
	@echo "Checking if path equals 'docker-stack'..."
	@if [[ "$(path)" == "./docker-compose/" ]]; then \
		echo "Please use the docker-compose.yml found in docker-stack instead"; \
		exit 1; \
	fi
	@echo "Starting docker swarm"
	docker swarm init
	docker stack deploy --compose-file $(path)docker-compose.yaml mongodb_cis_benchmarks --detach=false

docker-stack-remove: # Remove docker swarm and stack deployed
	@echo "Checking if path equals 'docker-stack'..."
	@if [[ "$(path)" == "./docker-compose/" ]]; then \
		echo "Please use the docker-compose.yml found in docker-stack instead"; \
		exit 1; \
	fi
	@echo "Remove deployed docker swarm"
	docker stack rm mongodb_cis_benchmarks
	docker swarm leave --force
