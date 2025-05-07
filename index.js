const { topicCreator, topicRemover } = require('./topic.js');
const { sendMessage } = require('./producer.js');


main = async () => {
    await topicCreator('Users');

    await sendMessage('Users', 'Ashley')
}

main()