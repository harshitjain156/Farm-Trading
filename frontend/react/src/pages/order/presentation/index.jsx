import NavBar from "../../../components/NavBar";
import React, { useEffect, useState } from "react";
import getAll from "../application/order";
import OrderItem from "../../../components/OrderItem";
import "@fortawesome/fontawesome-free/css/all.css";

import {toast, ToastContainer} from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import appState from "../../../data/AppState.js";
import {useHistory} from "react-router-dom";
import {SearchBar} from "../../../components/navbar/searchBar/SearchBar.jsx";
function Shop() {
  var [list, setList] = useState([]);
  const history = useHistory();


  useEffect(() => {
    window.scrollTo(0, 0);
    getAll().then((e) => {
      setList(e);
      console.log("Set List to ", e);
    });

    return () => {
      // Clean up here
    };
  }, []);
  useEffect(() => {
    if (!appState.isUserLoggedIn()) {
      history.push("/");
      toast("Your are not Logged in " );
    }
  }, []);

  return (
    <>
      {/*<NavBar />*/}
      {/*      <SearchBar mb={ {base: '10px', md: 'unset'}} me="10px" borderRadius="30px"/>*/}

      <section className="w-[100%] mt-[8vh] bg-white min-h-screen">
        <div className=" w-[100%] grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5 p-8 lg:p-10 ">

          {list.map((e, i) => {
            // console.log(list);
            return <OrderItem key={i} itemId={e._id} isCart={false} />;
          })}
        </div>
      </section>
    </>
  );
}

export default Shop;
