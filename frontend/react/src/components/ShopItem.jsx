import { motion } from "framer-motion";
import { useEffect, useState } from "react";
import Rating from "react-rating";
import { useHistory } from "react-router-dom";
import appState from "../data/AppState";
// import { addToCart, removeFromCart } from "../pages/Cart/application/cart";
import { deleteItem, getItem } from "../pages/shop/application/shop";
// import Button from "./Button";
import "@fortawesome/fontawesome-free/css/all.css";

import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

function ShopItem({ itemId, isCart = false }) {
  var [count, setCount] = useState(1);
  var [item, setItem] = useState(undefined);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getItem(itemId).then((data) => {
      setItem(data);
      setLoading(false);
    });
  }, []);

  const history = useHistory();


  console.log(loading, item);


  return (
    <>
      {item && (
        <motion.div
          key={item._id}
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          transition={{ delay: 0.25, duration: 0.25 }}
          viewport={{ once: true }}
          className="border border-slate-300 relative transition duration-500 rounded-lg hover:shadow-lg d bg-white "
        >
          <div className="h-40 w-[100%] relative">
            <img
              onClick={() => history.push("/item/" + item._id)}
              className="h-40 w-[100%] rounded-t-lg object-cover cursor-pointer hover:opacity-80"
              src={item.images[0]}
              alt=""
            />
            {!isCart && appState.getUserData().userType === "admin" && (

              <div
                onClick={async () => {
                  await deleteItem(itemId);
                  // window.location.reload();
                }}
                className="absolute top-2 right-2 ml-2 lg:ml-4 w-[40px] h-[40px] bg-red-400 flex justify-center items-center rounded-md cursor-pointer" >
                <i className="fa-solid fa-trash text-white"></i>
              </div>
            )}
          </div>

          <div className="px-4 py-2  rounded-lg ">
            <h1 className="text-xl font-bold text-gray-700 hover:text-gray-900 hover:cursor-pointer">
              {item.name}
            </h1>
            <div className="h-[1vh]"></div>
            <p className="text-lg text-gray-700 hover:text-gray-900">
              {item.farmer ? `Farmer: ` + item.farmer : `Farmer: ` + "Man Bahadur"}
            </p>

            <div className="text-lg" >
              Category: {item.category}
            </div>
            <p className="text-lg text-green-500 font-bold">
              {`रू ` + item.price + "/"+ item.quantityType}
            </p>
          </div>
          <div className="h-[1vh]"></div>
        </motion.div>
      )}
    </>
  );
}

export default ShopItem;
