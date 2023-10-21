const winston = require("winston");
const mongoose = require("mongoose");
const config = require("config");

module.exports = async function () {
  //TODO: Use below Url for local development
//var dbUrl = "mongodb://127.0.0.1:27017/agro-millets";
var dbUrl = "mongodb+srv://thapahimal777:xpF.8!2_D7jJUUc@cluster0.irrztq5.mongodb.net/?retryWrites=true&w=majority"
//  var dbUrl = process.env.DATABASE_URL;

  mongoose
    .connect(dbUrl, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    })
    .then(() => console.log("Connected to Database..."))
    .catch((err) => console.log(err));
};
