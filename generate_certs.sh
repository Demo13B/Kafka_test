# Generating CA
openssl req -new -x509 -keyout ca.key -out ca.crt -days 365 -nodes -subj "/CN=Kafka-CA"


# Generating keystore
keytool -genkey -alias kafka-broker \
  -keyalg RSA -keystore kafka.keystore.jks \
  -keysize 2048 -validity 365 \
  -dname "CN=kafka.example.com" \
  -storepass $STOREPASS -keypass $KEYPASS

# Creating certificate signing request
keytool -certreq -alias kafka-broker \
  -keystore kafka.keystore.jks \
  -file kafka.csr -storepass $STOREPASS

# Signing
openssl x509 -req -CA ca.crt -CAkey ca.key -in kafka.csr \
  -out kafka-signed.crt -days 365 -CAcreateserial

# importing CA certificate and signed key
keytool -import -alias CARoot \
  -keystore kafka.keystore.jks -file ca.crt \
  -storepass $STOREPASS -noprompt

keytool -import -alias kafka-broker \
  -keystore kafka.keystore.jks \
  -file kafka-signed.crt -storepass $STOREPASS

# Creating truststore
keytool -import -alias CARoot \
  -keystore kafka.truststore.jks -file ca.crt \
  -storepass $STOREPASS -noprompt


