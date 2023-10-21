const mongoose = require("mongoose");
const Joi = require("joi");
const {boolean} = require("joi");

const billingAddressSchema = new mongoose.Schema({
    fullName: {
        type: String,
        required: false,
    },
    email: {
        type: String,
        required: false,
    },
    phone: {
        type: String,
        required: false,
    },
    city: {
        type: String,
        required: false,
    },
    province: {
        type: String,
        required: false,
    },
    postalCode: {
        type: String,
        required: false,
    },
    areaName: {
        type: String,
        required: false,
    }, category: {
        type: String,
        required: false,
    },
    isDefaultBilling: {
        type: Boolean,
        default: false,
    },
    isDefaultShipping: {
        type: Boolean,
        default: false,
    },
});

const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        unique: true,
    },
    phone: {
        type: String,
        required: true,
        unique: true,
    },
    name: {
        type: String,
        required: true,
    },
    password: {
        type: String,
        required: true,
        min: 5,
        max: 1024,
    },
    newPassword: {
        type: String,
        required: false,
        min: 5,
        max: 1024,
    },
    userType: {
        type: String,
        enum: ["admin", "wholesaler", "farmer"],
        default: "wholesaler",
    },
    createdAt: {
        type: Date,
        default: () => {
            return new Date();
        },
    },
    latitude: {
        type: Number,
        required: true,
        min: 0,
    },
    longitude: {
        type: Number,
        required: true,
        min: 0,
    },
    resetPasswordToken: String,
    billingAddresses: [billingAddressSchema],
    resetPasswordExpires: Date,
});

userSchema.methods.isValidPassword = function (password) {
    return password === this.password;
};

const User = mongoose.model("User", userSchema);

function validateUser(user) {
    const schema = Joi.object().keys({
        name: Joi.string().required(),
        email: Joi.string().required().email(),
        password: Joi.string().required(),
        phone: Joi.string().required(),
        latitude: Joi.number().required(),
        longitude: Joi.number().required(),
        billingAddresses: Joi.array().items(Joi.object({
            city: Joi.string().allow(''),
            areaName: Joi.string().allow(''),
            postalCode: Joi.string().allow(''),
            fullName: Joi.string().allow(''),
            email: Joi.string().allow(''),
            phone: Joi.string().allow(''),
            province: Joi.string().allow(''),
            category: Joi.string().allow(''),
            isDefaultShipping: Joi.boolean().default(false),
            isDefaultBilling: Joi.boolean().default(false)
        })),
    });
    return schema.validate(user);
}

exports.User = User;
exports.validate = validateUser;
