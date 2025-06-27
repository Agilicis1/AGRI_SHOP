const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    nom: {
        type: String,
        required: true,
    },
    telephone: {
        type: String,
        required: false,
    },
    email: {
        type: String,
        required: false,
        unique: true,
        match: /.+\@.+\..+/
    },
    password: {
        type: String,
        required: true,
    },
    role: {
        type: String,
        required: true,
        enum: ['user', 'admin'],
        default: 'user',
    },
}, { timestamps: true });

const User = mongoose.model('User', userSchema);

module.exports = User;

