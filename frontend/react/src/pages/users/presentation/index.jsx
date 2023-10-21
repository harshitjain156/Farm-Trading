import NavBar from "../../../components/NavBar";
import React, { useEffect, useState } from "react";
import getAllUsers from "../application/user";
// import ShopItem from "../../../components/ShopItem";
import "@fortawesome/fontawesome-free/css/all.css";
import CheckTable from "../../../pages/admin/default/components/CheckTable";

import {toast, ToastContainer} from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import appState from "../../../data/AppState.js";
import {useHistory} from "react-router-dom";
import {SearchBar} from "../../../components/navbar/searchBar/SearchBar.jsx";
import {
  columnsDataCheck
} from "../../admin/default/variables/columnsData.jsx";
import tableDataCheck from "../../admin/default/variables/tableDataCheck.json";
function Users() {
  const [list, setList] = useState([]);
  const history = useHistory();

  useEffect(() => {
    window.scrollTo(0, 0);
    getAllUsers()
      .then((e) => {
        console.log(e);
        setList(e);
        console.log("Set List to ", e);
      })
      .catch((error) => {
        console.error("Error fetching users:", error);
      });

    return () => {
      // Clean up here
    };
  }, []);

  useEffect(() => {
    if (!appState.isUserLoggedIn()) {
      history.push("/");
      toast("You are not logged in");
    }
  }, []);

  const formattedUsers = list.filter(e => e.userType !== "admin").map((e) => ({
    name: [e.name, false],
    access: e.userType,
    date_joined: new Date(e.createdAt).toLocaleString(),
    email: e.email,
    phone: e.phone,
  }));

  return (
    <>
      <section className="w-[100%] mt-[8vh] bg-white min-h-screen">
                  <CheckTable columnsData={columnsDataCheck} tableData={formattedUsers} />
      </section>
    </>
  );
}

export default Users;
