const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    name: {
        type: String,
        required: false,
    },
    products: [
        {
            productId: {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'Product',
                required: true,
            },
            name: {
                type: String,
                required: false,
            },
            quantity: {
                type: Number,
                required: true,
            },
            price: {
                type: Number,
                required: true,
            },
            phone: {
                type : String,
                required : false,
            }, 
            modepayement: {
                type : String,
                enum : ['espece', 'orange Money', 'wave'],
                required : false,
            }
        }
    ],
    status: {
        type: String,
        enum: ['pending', 'paid', 'shipped', 'delivered', 'cancelled'],
        default: 'pending',
    },
    phone: String,
    paymentMethod: String
},{ timestamps: true });

const Order = mongoose.model('Order', orderSchema);

module.exports = Order;
