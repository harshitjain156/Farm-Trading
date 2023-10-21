const express = require("express");
const router = express.Router();
const { getSuccessResponse, getErrorResponse } = require("../utils/response");
const { User } = require("../models/user");
const _ = require("lodash");
const { default: mongoose } = require("mongoose");
const { MilletItem } = require("../models/millet_item");
const {MilletOrder} = require("../models/order_item");

//TODO: Add Admin functions

// Add a function to check if user is admin
router.get("/isAdmin/:userId", async function (req, res) {});

// Delete an Item
// Body: {itemId: ObjectId, adminId: ObjectId}
router.post("/deleteItem", async (req, res) => {
  var { itemId, adminId } = req.body;

  // Check and validate itemId
  if (!mongoose.Types.ObjectId.isValid(itemId)) {
    return res.status(404).send(getErrorResponse("Invalid Item ID"));
  }
  // Check and validate adminId
  if (!mongoose.Types.ObjectId.isValid(adminId)) {
    return res.status(404).send(getErrorResponse("Invalid Admin ID"));
  }

  var user = await User.findOne({ _id: adminId });
  // console.log(user);
  if (user.userType !== "farmer" && user.userType !== "admin") {
    return res.status(404).send(getErrorResponse("You don't have permission to delete items."));
  }

  // When mongoose deletes an item it returns it as well
  var deletedItem = await MilletItem.findByIdAndDelete(itemId);

  if (!deletedItem) {
    return res
      .status(404)
      .send(getErrorResponse("Item with ID provided not found!"));
  }

  return res.send(getSuccessResponse("Deleted Item", deletedItem));
});
module.exports = router;
