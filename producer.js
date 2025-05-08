const { Kafka } = require('kafkajs');
const fs = require('fs');
require('dotenv').config();

sendMessage = async (topicName, message) => {
    try {
        // Начало как в topic
        const kafka = new Kafka({
            'clientId': 'topic_manager',
            'brokers': ['demo13b.ddnsfree.com:19093'],
            'ssl': {
                'ca': [fs.readFileSync('./creds/ca.crt')],
                'rejectUnauthorized': true
            }
        });
        const producer = kafka.producer();

        console.log('Connecting to broker.....')
        await producer.connect();
        console.log('Connected')

        /**
         * Отправляем message в topicName
         * 
         * Получаем response
         */
        part = message[0] < 'N' ? 0 : 1;
        const response = await producer.send({
            'topic': topicName,
            'acks': -1,
            'messages': [{
                'value': message,
                'partition': part
            }]
        })

        console.log(`Sent successfully!\n${JSON.stringify(response)}`);
        await producer.disconnect();
        console.log('Diconnected');
    } catch (ex) {
        console.error(ex.message);
    }

}

module.exports = { sendMessage };