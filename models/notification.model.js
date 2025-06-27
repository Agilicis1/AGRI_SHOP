
const mongoose = require('mongoose');
const notificationSchema = new mongoose.Schema({

    title: String, 
    message : String,
    type : String , 
    orderId : String,
    read : Boolean,
}); 
const Notification = mongoose.model('Notification', notificationSchema);

module.exports = Notification;

