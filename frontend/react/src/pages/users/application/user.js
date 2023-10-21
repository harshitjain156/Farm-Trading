import axios from "axios";
import { API_URL } from "../../../constants";
import { toast } from "react-toastify";
import appState from "../../../../src/data/AppState";


export default async function getAllUsers() {
//  var res = await axios.POST(API_URL + "/auth/getAll");

    var res = await axios.post(API_URL + "/auth/getAll", {
            adminId: appState.getUserData()._id,
      });
  console.log(res);
  return res.data.data;
}

//export async function getItem(id) {
//  try {
//    var res = await axios.get(API_URL + "/list/getItem/" + id);
//    console.log(res);
//    return res.data.data;
//  } catch (e) {
//    return undefined;
//  }
//}

//export async function addComment(comment) {
//  console.log(comment, appState.getUserData());
//  if (!appState.isUserLoggedIn()) {
//    toast.error("You must be logged in to add a comment");
//    return 0;
//  }
//
//
//  console.log(res);
//  return 1;
//}

// http://localhost:3000/api/admin/deleteItem
//export async function deleteItem(itemId) {
//  if (
//    !appState.isUserLoggedIn() ||
//    appState.getUserData().userType != "admin"
//  ) {
//    toast.error("You must be an admin to delete an item");
//    return 0;
//  }
//
//  var res = await axios.post(API_URL + "/admin/deleteItem", {
//    adminId: appState.getUserData()._id,
//    itemId: itemId,
//  });
//
//  if (res.data.statusCode == 200) {
//    toast.success(res.data.message);
//  }
//
//  console.log(res);
//  return 1;
//}
