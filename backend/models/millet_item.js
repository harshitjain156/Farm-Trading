const mongoose = require("mongoose");
const Joi = require("joi");
const JoiObjectId = require("joi-objectid")(Joi);
const { commentSchema } = require("./comment");

const milletItemSchema = new mongoose.Schema({
  listedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  farmer: {
    type: String,
    required: false,
  },
  name: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  images: {
    type: [String],
    required: true,
  },
  quantityType: {
    type: String,
    required: true,
    min: 0,
  },
  quantity: {
    type: Number,
    required: true,
    min: 0,
  },
  price: {
    type: Number,
    required: true,
    min: 0,
  },

  listedAt: {
    type: Date,
    default: () => {
      return new Date();
    },
  },
  comments: [commentSchema],
});

const MilletItem = mongoose.model("MilletItem", milletItemSchema);

function validateMilletItem(item) {
  const schema = Joi.object().keys({
    listedBy: JoiObjectId().required(),
    name: Joi.string().required(),
    farmer: Joi.string(),
    category: Joi.string().required(),
    description: Joi.string().required(),
    images: Joi.array().items(Joi.string().required()).required(),
    comments: Joi.array(),
    quantityType: Joi.string().required(),
    quantity: Joi.number().required(),
    price: Joi.number().required(),
  });
  return schema.validate(item);
}

exports.MilletItem = MilletItem;
exports.validateMilletItem = validateMilletItem;
exports.milletItemSchema = milletItemSchema;
