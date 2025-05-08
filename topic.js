const { Kafka } = require('kafkajs');
const fs = require('fs');
require('dotenv').config();

topicCreator = async (topicName) => {
    try {
        /* Создаем новое подключение к Kafka
        *
        * Здесь client_id - любая строка, уникальный идентификатор
        * 
        * brokers - список брокеров, с которыми хотим общаться
        *
        */
        const kafka = new Kafka({
            'clientId': 'topic_manager',
            'brokers': ['demo13b.ddnsfree.com:19093'],
            'ssl': {
                'ca': [fs.readFileSync('./creds/ca.crt')],
                'rejectUnauthorized': true
            }
        });


        // Подключаемся
        const admin_connection = kafka.admin();
        console.log('Connecting.....');
        await admin_connection.connect();
        console.log('Connected');


        /**
         * Создаем topic
         * 
         * Здесь topics - список объектов.
         * 
         * topic - поле с именем нового topic
         * 
         * numPartitions - количество партиций в topic 
         */
        await admin_connection.createTopics({
            'topics': [{
                'topic': topicName,
                'numPartitions': 2
            }]
        });
        console.log(`Topic ${topicName} created successfully`);

        // Отключаемся
        await admin_connection.disconnect();
        console.log('Diconnected');





    } catch (ex) {
        console.error(ex.message);
    }
}

topicRemover = async (topicName) => {
    const kafka = new Kafka({
        'clientId': 'topic_manager',
        'brokers': [process.env.KAFKA_BROKER],
        'ssl': {
            'ca': [fs.readFileSync('./creds/ca.crt')],
            'rejectUnauthorized': true,
            'checkServerIdentity': () => undefined,
            'passphrase': 'confluent'
        }
    });

    // Подключаемся
    const admin_connection = kafka.admin();
    console.log('Connecting.....');
    await admin_connection.connect();
    console.log('Connected');

    // Удаляем
    await admin_connection.deleteTopics({
        'topics': [topicName]
    });
    console.log(`Topic ${topicName} deleted successfully`);

    // Отключаемся
    await admin_connection.disconnect();
    console.log('Diconnected');
}


// main = async () => {
//     await topicCreator('Users');

//     await topicRemover('Users');
// }

// main();

module.exports = { topicCreator, topicRemover }

topicCreator('Users')