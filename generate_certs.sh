openssl req -new -nodes \
   -x509 \
   -days 365 \
   -newkey rsa:2048 \
   -keyout ./ca.key \
   -out ./ca.crt \
   -config ./ca.cnf

cat ./ca.crt ./ca.key > ./ca.pem

openssl req -new \
    -newkey rsa:2048 \
    -keyout ./broker.key \
    -out ./broker.csr \
    -config ./broker.cnf \
    -nodes

openssl x509 -req \
    -days 3650 \
    -in ./broker.csr \
    -CA ./ca.crt \
    -CAkey ./ca.key \
    -CAcreateserial \
    -out ./broker.crt \
    -extfile ./broker.cnf \
    -extensions v3_req

openssl pkcs12 -export \
    -in ./broker.crt \
    -inkey ./broker.key \
    -chain \
    -CAfile ./ca.pem \
    -name broker \
    -out ./broker.p12 \
    -password pass:<password>

keytool -importkeystore \
    -deststorepass <password> \
    -destkeystore ./kafka.broker.keystore.pkcs12 \
    -srckeystore ./broker.p12 \
    -deststoretype PKCS12  \
    -srcstoretype PKCS12 \
    -noprompt \
    -srcstorepass <password>

keytool -list -v \
    -keystore ./kafka.broker.keystore.pkcs12 \
    -storepass <password>



# Client key
openssl req -new \
    -newkey rsa:2048 \
    -keyout ./client.key \
    -out ./client.csr \
    -config ./broker.cnf \
    -nodes

openssl x509 -req \
    -days 3650 \
    -in ./client.csr \
    -CA ./ca.crt \
    -CAkey ./ca.key \
    -CAcreateserial \
    -out ./client.crt \
    -extfile ./broker.cnf \
    -extensions v3_req

openssl pkcs12 -export \
    -in ./client.crt \
    -inkey ./client.key \
    -chain \
    -CAfile ./ca.pem \
    -name client \
    -out ./client.p12 \
    -password pass:<password>

keytool -importkeystore \
    -deststorepass <password> \
    -destkeystore ./kafka.broker.truststore.pkcs12 \
    -srckeystore ./client.p12 \
    -deststoretype PKCS12  \
    -srcstoretype PKCS12 \
    -noprompt \
    -srcstorepass <password>