import {motion} from "framer-motion";
import React, {useEffect, useState} from "react";
import Rating from "react-rating";
import {useHistory, useParams} from "react-router-dom";
// import appState from "../data/AppState";
// import { addToCart, removeFromCart } from "../pages/Cart/application/cart";
import {deleteItem, getItem, getOrderItem} from "../application/order";
// import Button from "./Button";
import "@fortawesome/fontawesome-free/css/all.css";

import {ToastContainer} from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import {
  MdAirportShuttle,
  MdApps,
  MdCheckCircle,
  MdClose, MdDangerous,
  MdLocalShipping,
  MdMultipleStop, MdOutlineCheck, MdOutlineDangerous,
  MdOutlineInventory2, MdPublishedWithChanges,
  MdSchedule
} from "react-icons/md";
import {Icon} from "@chakra-ui/react";

function ItemOrderDetail() {
  const { id } = useParams();
  var [count, setCount] = useState(1);
  var [item, setItem] = useState(undefined);
  var [order, setOrder] = useState(undefined);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
      getOrderItem(id)
        .then((orderData) => {
          if (orderData) {
            setOrder(orderData);
            return getItem(orderData.item);
          } else {
            return undefined;
          }

        })
        .then((itemData) => {
          console.log('-----item-----');
          console.log(itemData);
          setItem(itemData);
          // setLoading(false);
        })
        .catch((error) => {
          console.error('Error fetching data:', error); // Add this line to log the specific error
        });
    setLoading(false);
  }, [id]);

  const history = useHistory();


  console.log(loading, item);
  console.log(loading, order);


  return (
      <>
        {order && item && (
            <motion.div
                key={order._id}
                initial={{opacity: 0}}
                whileInView={{opacity: 1}}
                transition={{delay: 0.25, duration: 0.25}}
                viewport={{once: true}}
                className="border border-slate-300 relative transition duration-500 rounded-lg hover:shadow-lg d bg-white "
            >


              <div className="h-[1vh]"></div>

              <section className="min-h-[52vh] w-[100%] p-6 lg:p-12 ">
                <div className="flex flex-col lg:flex-row">
                  <img
                      className="object-cover w-50 h-50 lg:w-80 lg:h-60 bg-white border-slate-300 rounded-md border-2 p-4"
                      src={item.images}
                      alt=""
                  />


                  <div className="flex flex-col pl-8 mt-5 lg:mt-0">
                    <h1 className="pb-2 text-5xl font-bold">{item.name}</h1>
                    <p className="text-lg text-gray-700 hover:text-gray-900">
                      {item.farmer ? `Farmer: ` + item.farmer : `Farmer: ` + "Man Bahadur"}
                    </p>
                    <br></br>

                    <div className="flex flex-row items-end">
                      <h1 className="pb-0 text-4xl font-bold text-accentColor">
                        {`रू ` + order.price}
                      </h1>
                    </div>
                    <br></br>

                    <div className="flex flex-row items-end">
                      <h1 className="text-lg text-gray-700 hover:text-gray-900">
                        {"Order Id: " + id}
                      </h1>
                    </div>
                    <br></br>

                    <div className="flex flex-row items-end">
                      <h1 className="text-lg text-gray-700 hover:text-gray-900">
                        {"Payment Method: " + order.modeOfPayment}
                      </h1>
                    </div>
                    <br></br>

                    <p className="text-lg"> Description: {item.description}</p>
                    <br></br>

                    <div className="flex flex-row justify-between">

                      <p className="text-lg font-bold">
                        {"Payment :  "} { order.isPaid ? <Icon
                          as={MdCheckCircle}
                          width='20px'
                          height='20px'
                          color='green'/> :  <Icon
                          as={MdDangerous}
                          width='20px'
                          height='20px'
                          color='red'/>}
                      </p>
                    </div>


                    {/*<p className="text-lg text-green-500 font-bold">*/}
                    {/*  */}
                    {/*</p>*/}


                    <div className="h-[1vh]"></div>
                    <div className="flex flex-row justify-between">
                      {/* Category */}
                      <div
                          className="w-[45%] h-[40px] flex flex-row items-center justify-center border border-gray-300 rounded-md px-2">
                        <div className="flex-1 h-[100%] flex justify-center items-center text-center">
                          {item.category}
                        </div>
                      </div>
                      <br></br>

                      {/* Status */}
                      <div
                          className="w-[52%] h-[40px] flex flex-row items-center justify-center  rounded-md px-2">
                        <div className="flex-1 h-[100%] flex justify-center items-center text-center">
                          {order.status && (
                              <div className="ml-2 lg:ml-4 w-[80px] h-[40px] flex gap-3 justify-center  items-center rounded-md">
                                {order.status}

                                {order.status == "Delivering" && (
                                    <Icon
                                        as={MdLocalShipping}
                                        width='20px'
                                        height='20px'
                                        color='green'/>
                                )}
                                {order.status == "Packaging" && (
                                    <Icon
                                        as={MdOutlineInventory2}
                                        width='20px'
                                        height='20px'
                                        color='green'/>
                                )}
                                {order.status == "Processing" && (
                                    <Icon
                                        as={MdPublishedWithChanges}
                                        width='20px'
                                        height='20px'
                                        color='green'/>
                                )}
                                {order.status == "Delivered" && (
                                    <Icon
                                        as={MdAirportShuttle}
                                        width='20px'
                                        height='20px'
                                        color='green'/>
                                )}
                              </div>
                          )}
                        </div>
                      </div>
                    </div>

                  </div>
                </div>
              </section>
              {/* Comments Section */}
              <div className="flex flex-col md:flex-row mt-5   h-[8vh] mx-5 md:mx-12">
              </div>
            </motion.div>
        )}
      </>
  );
}

export default ItemOrderDetail;