#!/bin/bash

if [[ -f zpalotas.key && -f zpalotas.crt ]]; then
	echo Certificate already exists! 
	exit 0
else
	echo Issuing new certificate... 
	rm -f zpalotas.key zpalotas.csr zpalotas.crt
fi

#: Generating a private key
#: 4096 bit RSA which is stronger than 2024 
#: NOTE: -aes256 could make it password protected but adds complexity in docker environment
openssl genrsa -out zpalotas.key 4096

#: Creating the CSR (Certificate Signing Request)
#: This could be sent to Certifying Authority or to the next step for self-signing
#: SAN = Subject Alternative Name: specifies which domain names or IP addresses the certificate is valid for.
openssl req -nodes -new \
	-key zpalotas.key \
	-out zpalotas.csr \
	-subj "/CN=zpalotas.42.fr" \
	-addext "subjectAltName=DNS:zpalotas.42.fr,DNS:www.zpalotas.42.fr,DNS:localhost,IP:127.0.0.1"

#: Create the certificate
#: valid for x days
#: based on the request and private key
#: copies SAN information of the request (subj and addext) into the certificate (important for modern  )
openssl x509 -req -sha256 \
	-days 3650 \
	-in zpalotas.csr \
	-signkey zpalotas.key \
	-out zpalotas.crt \
	-copy_extensions copy

#: Not needed after the certificate was successfully created
rm -f zpalotas.csr

#: !!!!!!!!!!!
#: !ATTENTION! add .key to .gitignore. Your private key is a secret
#: !!!!!!!!!!!