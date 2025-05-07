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
    -keyout ./kafka-1.key \
    -out ./kafka-1.csr \
    -config ./broker.cnf \
    -nodes

openssl x509 -req \
    -days 3650 \
    -in ./kafka-1.csr \
    -CA ./ca.crt \
    -CAkey ./ca.key \
    -CAcreateserial \
    -out ./kafka-1.crt \
    -extfile ./broker.cnf \
    -extensions v3_req

openssl pkcs12 -export \
    -in ./kafka-1.crt \
    -inkey ./kafka-1.key \
    -chain \
    -CAfile ./ca.pem \
    -name kafka-1 \
    -out ./kafka-1.p12 \
    -password pass:confluent

keytool -importkeystore \
    -deststorepass confluent \
    -destkeystore ./kafka.kafka-1.keystore.pkcs12 \
    -srckeystore ./kafka-1.p12 \
    -deststoretype PKCS12  \
    -srcstoretype PKCS12 \
    -noprompt \
    -srcstorepass confluent

keytool -list -v \
    -keystore ./kafka.kafka-1.keystore.pkcs12 \
    -storepass confluent

