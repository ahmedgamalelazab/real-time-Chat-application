require('dotenv').config({path : './config.env'});
const express = require('express');
const app = express();
const server = require('http').createServer(app);
const io = require('socket.io')(server,{
    origin:{
        cors:'*'
    }
});
const helmet = require('helmet');
const morgan = require('morgan');
const cors = require('cors');


app.use(cors());
app.use(express.json());
app.use(helmet());
app.use(morgan('common'));

io.on('connection',(socket)=>{
    console.log('new WS connection');
    console.log(socket.id);
    //catch the state of entring the room 
    let chatRoomuserName = '';
    let chatRoom = '';
    socket.on('userEnterRoom',(msg)=>{
        const messageParser = JSON.parse(msg);
        console.log(msg);
        chatRoomuserName = messageParser['userName'];
        chatRoom = messageParser['room'];
        socket.join(chatRoom);
        socket.broadcast.to(chatRoom).emit('message',`${messageParser['userName']} joined the ${messageParser['room']} room`);

    });
    //on client connect we will send form him hello to chatCord
    socket.emit('message','welcome to ChatCord App');
   
    
    socket.on('userMessage',(msg)=>{
        const clientMessage = JSON.parse(msg);
        console.log(clientMessage);
        const {userMessage,
        messageType,
        messageFrom,
        messageTo} = clientMessage;
        const response = {
            userMessage : userMessage,
            messageType : "server",
            messageFrom : messageFrom,
            messageTo : messageTo
        }
        console.log(response);
        const responseParser = JSON.stringify(response);
        console.log(responseParser);
        io.to(chatRoom).emit('serverMessage',responseParser);
    });

    
    //on client disconnect
    socket.on('disconnect',()=>{
        console.log('device Disconnected');
        socket.broadcast.to(chatRoom).emit('message',`${chatRoomuserName} had left the ${chatRoom} room`);
    })


})





server.listen(process.env.PORT ,'0.0.0.0', ()=>console.log(`server on and listeining or port ${process.env.PORT}`));
