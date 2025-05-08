const { Kafka } = require('kafkajs');
const fs = require('fs');
require('dotenv').config();

startConsumer = async (topicName) => {
    try {
        const kafka = new Kafka({
            'clientId': 'topic_manager',
            'brokers': ['demo13b.ddnsfree.com:19093'],
            'ssl': {
                'ca': [fs.readFileSync('./creds/ca.crt')],
                'rejectUnauthorized': true,
                'cert': fs.readFileSync('./creds/client.crt'),
                'key': fs.readFileSync('./creds/client.key')
            }
        });

        const consumer = kafka.consumer({ 'groupId': '1' });

        console.log('Connecting....');
        await consumer.connect();
        console.log('Connected');

        // consumer подписывается на topic
        await consumer.subscribe({
            'topic': topicName,
            'fromBeginning': true
        });


        /**
         * Далее consumer запускается и ему передается функция для выполнения после получения каждого сообщения.
         * 
         * Обратите внимание, что consumer работает в фоне и disconnsct не происходит
         */
        await consumer.run({
            'eachMessage': async (result) => {
                console.log(`${result.message.value}`);
            }
        });
    } catch (ex) {
        console.error(ex.message);
    }
}

startConsumer('Users')