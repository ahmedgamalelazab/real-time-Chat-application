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
    

    //on client connect we will send form him hello to chatCord
    socket.emit('message','welcome to ChatCord App');
    io.emit('message','USER joined the room');
    
    socket.on('userMessage',(msg)=>socket.broadcast.emit('message',msg));


    //on client disconnect
    socket.on('disconnect',()=>{
        console.log('device Disconnected');
        socket.broadcast.emit('message','User left the room');
    })


})







server.listen(process.env.PORT ,'0.0.0.0', ()=>console.log(`server on and listeining or port ${process.env.PORT}`));
