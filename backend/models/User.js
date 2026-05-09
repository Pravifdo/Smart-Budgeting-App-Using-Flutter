const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    },
    job: {
        type: String,
        default: "Software Engineer"
    },
    location: {
        type: String,
        default: "Sri Lanka"
    },
    profileImage: {
        type: String,
        default: ""
    }
});

module.exports = mongoose.model('User', userSchema);