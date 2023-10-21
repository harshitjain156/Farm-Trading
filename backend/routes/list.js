const express = require("express");
const router = express.Router();
const {getErrorResponse, getSuccessResponse} = require("../utils/response");
const {MilletItem, validateMilletItem} = require("../models/millet_item");
const {MilletOrder, validateMilletOrder} = require("../models/order_item");
const {Comment, validateComment} = require("../models/comment");
const {Cart} = require("../models/cart");
const {User} = require("../models/user");
const mongoose = require("mongoose");
const json2csv = require('json2csv').parse;
const fs = require('fs');
const {spawn} = require('child_process');
const {execFile} = require('child_process');

router.get("/getRecent", async (req, res) => {
    const items = await MilletItem.find().sort({dateField: -1}).limit(5);

    return res.send(getSuccessResponse("Success!", items));
});

router.get("/getAll", async (req, res) => {
    const items = await MilletItem.find({});
    return res.send(getSuccessResponse("Success!", items));
});

router.get("/getAllOrders", async (req, res) => {
    const items = await MilletOrder.find({});
    // console.log(items);
    // console.log("--testing--");
    return res.send(getSuccessResponse("Success!", items));
});
router.post("/orderPaid", async (req, res) => {
    var {itemId} = req.body;

    // console.log('insideeeeee');
    if (!mongoose.Types.ObjectId.isValid(itemId)) {
        return res.status(404).send(getErrorResponse("Invalid Item ID"));
    }


    const filter = {_id: itemId};
    const update = {isPaid: true};

    const result = await MilletOrder.findByIdAndUpdate(filter, update, {new: true});


    if (result) {
        return res.send({message: "Order updated successfully"});
    } else {
        return res.status(404).send({message: "Order not found"});
    }

});

router.post("/removeOrder", async (req, res) => {
    var {itemId} = req.body;


    if (!mongoose.Types.ObjectId.isValid(itemId)) {
        return res.status(404).send(getErrorResponse("Invalid Item ID"));
    }

    const result = await MilletOrder.findByIdAndDelete(itemId);

    if (result) {
        return res.send({message: "Order deleted successfully"});
    } else {
        return res.status(404).send({message: "Order not found"});
    }
});


router.post("/getRecommendations", async (req, res) => {
    const {itemID} = req.body;
    // console.log(itemID);
    // Fetch all items from MongoDB
    const items = await MilletItem.find({});
    try {


        // Map the retrieved data to the required fields for CSV conversion
        const mappedItems = items.map((item) => ({
            id: item.id,
            farmer_id: item.listedBy,
            product_name: item.name,
            category: item.category,
            quantity: item.quantity,
        }));

        // Convert the mapped data into CSV format
        const fields = ['id', 'farmer_id', 'product_name', 'category', 'quantity'];
        const opts = {fields, header: true};
        const csvData = json2csv(mappedItems, opts);

        // Write the CSV data to a file
        fs.writeFileSync('output.csv', csvData, 'utf-8');
        console.log('CSV file saved successfully as "output.csv"');
    } catch (error) {
        console.error('Error while saving data to CSV:', error);
    }
    const pythonScript = 'recommendations.py';
    const productToSearch = itemID; // Replace this with the product id you want to search
    execFile('python3', [pythonScript, productToSearch], (error, stdout, stderr) => {
        if (error) {
            console.error(`Error executing the Python script: ${error.message}`);
            return;
        }
        const milletItemIds = JSON.parse(stdout);
        // Query to filter MilletItems based on the list of IDs
        const items = MilletItem.find({_id: {$in: milletItemIds}})
            .then((filteredItems) => {
//              console.log("Filtered MilletItems:");
//              console.log(filteredItems);
                return res.send(getSuccessResponse("Success!", filteredItems));

            })
            .catch((err) => {
                console.error("Error filtering MilletItems:", err);
            })
    });


});
router.get("/getOrderRecommendations/:itemID", async (req, res) => {
    var itemID = req.params.itemID;
    // Fetch all items from MongoDB
    try {
        // Fetch the item by itemID from MongoDB

        // const orderItem = await MilletOrder.findOne({ _item: itemID }); // Assuming itemID is the MongoDB document _id
        const orderItem = await MilletOrder.findOne({ item: itemID });
        let filteredOrderItems = await MilletOrder.find({listedBy:orderItem.listedBy});

        const uniqueItemIDs = Array.from(new Set(filteredOrderItems.map(item => item.item.toString())));
        // Remove the current itemID from uniqueItemIDs
        const filteredUniqueItemIDs = uniqueItemIDs.filter(id => id !== itemID);
        if (!filteredUniqueItemIDs) {
            return res.status(404).json({ error: 'Item not found' });
        }

        const items = MilletItem.find({_id: {$in: filteredUniqueItemIDs}})
            .then((filteredItems) => {
//              console.log("Filtered MilletItems:");
//              console.log(filteredItems);
                return res.send(getSuccessResponse("Success!", filteredItems));

            })
            .catch((err) => {
                console.error("Error filtering MilletItems:", err);
                return res.status(404).json({ error: 'Item not found' });
            })

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Server error' });
    }

});

router.get("/getAll/:farmerID", async (req, res) => {
    var farmerID = req.params.farmerID;
    if (!mongoose.Types.ObjectId.isValid(farmerID)) {
        return res.status(404).send(getErrorResponse("Invalid User ID"));
    }

    let items = await MilletItem.find({});

    //TODO: Check if this works
    items = items.filter((item) => item.listedBy.toString() === farmerID);

    return res.send(getSuccessResponse("Success", items));
});

router.post("/addItem", async (req, res) => {
    console.log(req.body);
    const {error} = validateMilletItem(req.body);
    if (error) return res.send(getErrorResponse(error.details[0].message));

    if (!mongoose.Types.ObjectId.isValid(req.body.listedBy)) {
        return res.status(404).send(getErrorResponse("Invalid User ID"));
    }

    let item = new MilletItem(req.body);
    await item.save();

    return res.send(getSuccessResponse("Added Item", item));
});

router.get("/getItem/:id", async (req, res) => {
    console.log(req.params.id);
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
        return res.status(404).send(getErrorResponse("Invalid Product ID"));
    }
    let item = await MilletItem.findOne({_id: req.params.id});
    if (!item) {
        return res.status(404).send(getErrorResponse("No Product Found"));
    }
    return res.send(getSuccessResponse("Success", item));
});
router.get("/getOrderItem/:id", async (req, res) => {
    console.log(req.params.id);
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
        return res.status(404).send(getErrorResponse("Invalid Product ID"));
    }
    let item = await MilletOrder.findOne({_id: req.params.id});
    console.log(item);
    if (!item) {
        return res.status(404).send(getErrorResponse("No Product Found"));
    }
    return res.send(getSuccessResponse("Success", item));
});

router.post("/comment", async (req, res) => {
    const {commentBy, itemID} = req.body;
    if (!mongoose.Types.ObjectId.isValid(itemID)) {
        return res.status(404).send(getErrorResponse("Invalid Item ID"));
    }
    let item = await MilletItem.findOne({_id: itemID});

    if (!mongoose.Types.ObjectId.isValid(commentBy)) {
        return res.status(404).send(getErrorResponse("Invalid User ID"));
    }

    // let user = User.findOne({ _id: userID });

    const {error} = validateComment(req.body);
    if (error) return res.send(getErrorResponse(error.details[0].message));

    let comment = new Comment(req.body);
    item.comments.push(comment);
    await item.save();

    return res.send(getSuccessResponse("Added Comment", item));
});

router.post("/getComments", async (req, res) => {
    const {itemID} = req.body;
    if (!mongoose.Types.ObjectId.isValid(itemID)) {
        return res.status(404).send(getErrorResponse("Invalid Item ID"));
    }
    let item = await MilletItem.findOne({_id: itemID});
    return res.send(getSuccessResponse("Success!", item.comments));
});

router.post("/getUsers", async (req, res) => {
    var data = req.body;
    console.log(`Update User `, data);
    if (!mongoose.Types.ObjectId.isValid(data._id)) {
        return res.status(404).send(getErrorResponse("Invalid User ID"));
    }

    let items = await User.find({});
    return res.send(getSuccessResponse("Success!", items));
});

// order
router.post("/addOrder", async (req, res) => {
    console.log(req.body);
    var quantity_to_be_reduced = req.body.quantity;
    let orderd_item = await MilletItem.findOne({_id: req.body.item});
    var final_item_quantity = orderd_item.quantity - quantity_to_be_reduced
    var itemID = req.body.item;

    const {error} = validateMilletOrder(req.body);
    if (error) return res.send(getErrorResponse(error.details[0].message));

    if (!mongoose.Types.ObjectId.isValid(req.body.listedBy)) {
        return res.status(404).send(getErrorResponse("Invalid User ID"));
    }

    let item = new MilletOrder(req.body);
    await item.save();

    const filter = {_id: itemID};
    const update = {$set: {quantity: final_item_quantity}};

    try {
        await MilletItem.updateOne(filter, update);
        console.log("Item quantity updated successfully!");
    } catch (error) {
        console.error("Error updating item quantity:", error);
        // Handle the error accordingly
    }
    // After successfully adding the order, delete the corresponding cart item
    if (req.body.modeOfPayment=='cash_on_delivery') {
        var cart = await Cart.findOne({userId: req.body.listedBy});

        if (!cart) {
            return res
                .status(404)
                .send(getErrorResponse("No cart exists for this userId"));
        }

        const len = cart.items.length;

        // If itemId doesn't match, add it back to list
        cart.items = cart.items.filter((e) => e.item.toString() !== item.item.toString());

        if (cart.items.length === len) {
            // No item was removed, means it doesn't exist
            return res
                .status(404)
                .send(getErrorResponse("No item of this ID is present in your cart"));
        }

        await cart.save();
        console.log("Cart item deleted successfully!");
    }



    return res.send(getSuccessResponse("Order is Added", item));
});

// Define an endpoint to update order status
router.post('/updateOrderStatus', async (req, res) => {
    try {
        const {orderId, newStatus} = req.body;

        if (!mongoose.Types.ObjectId.isValid(orderId)) {
            return res.status(404).send(getErrorResponse('Invalid Order ID'));
        }

        const updatedOrder = await MilletOrder.findByIdAndUpdate(
            orderId,
            {$set: {status: newStatus}},
            {new: true}
        );
        console.log('------');
        console.log(updatedOrder);
        if (!updatedOrder) {
            return res.status(404).send(getErrorResponse('Order not found'));
        }
        await updatedOrder.save();

        return res.send(getSuccessResponse('Order status updated', updatedOrder));
    } catch (error) {
        console.error('Error updating order status:', error);
        return res.status(500).send(getErrorResponse('An error occurred'));
    }
});

router.get("/getAllDeliveries/:farmerID", async (req, res) => {
    var farmerID = req.params.farmerID;
    if (!mongoose.Types.ObjectId.isValid(farmerID)) {
        return res.status(404).send(getErrorResponse("Invalid User ID"));
    }

    let items = await MilletOrder.find({});
    // console.log(items);
    //TODO: Check if this works
    items = items.filter((item) => item.farmerId.toString() === farmerID).sort((a, b) => b.listedAt - a.listedAt);
    ;

    return res.send(getSuccessResponse("Success", items));
});
router.get("/getAllOrder/:wholesalerID", async (req, res) => {
    var wholesalerID = req.params.wholesalerID;
    if (!mongoose.Types.ObjectId.isValid(wholesalerID)) {
        return res.status(404).send(getErrorResponse("Invalid User ID"));
    }

    let user = await User.findOne({_id: wholesalerID});
    let items = await MilletOrder.find({});
    if (user.userType == "admin") {
        console.log(items);
        return res.send(getSuccessResponse("Success", items));

    } else {
        //TODO: Check if this works
        items = items
            .filter((item) => item.listedBy.toString() === wholesalerID)
            .sort((a, b) => b.listedAt - a.listedAt);
    }

    return res.send(getSuccessResponse("Success", items));
});

module.exports = router;