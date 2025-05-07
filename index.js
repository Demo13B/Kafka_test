const { sendMessage } = require('./producer.js');

main = async () => {
    await sendMessage('Users', 'Doggo')
}

main()