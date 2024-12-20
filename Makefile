path := "./docker-compose/"

.PHONY: help

help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

clean: # Remove generated keys from directory
	rm -f $(path)keyfile $(path)*.key $(path)*.pem $(path)*.csr $(path)*.srl 

generate-keyfile: # Generate keyfile for access control for replica sets (https://www.mongodb.com/docs/manual/tutorial/enforce-keyfile-access-control-in-existing-replica-set/#create-a-keyfile)
	openssl rand -base64 756 > $(path)keyfile
	chmod 400 $(path)/keyfile

generate-self-signed-ca: # Generate a self-signed CA certificate
	openssl req -new -x509 -days 365 -out $(path)ca.pem -keyout $(path)ca.key

generate-server-key: # Generate a server key
	openssl genpkey -algorithm RSA -out $(path)server.key

generate-ca-signing-request: # Generate a certificate signing request (CSR) for the server
	openssl req -new -key $(path)server.key -out $(path)server.csr

sign-server-csr-with-ca: generate-server-key generate-self-signed-ca generate-ca-signing-request # Sign the server CSR with the CA certificate
	openssl x509 -req -in $(path)server.csr -CA $(path)ca.pem -CAkey $(path)ca.key -CAcreateserial -out $(path)server.pem -days 365
