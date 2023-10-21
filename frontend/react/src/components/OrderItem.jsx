import {motion} from "framer-motion";
import React, {useEffect, useState} from "react";
import Rating from "react-rating";
import {useHistory} from "react-router-dom";
import appState from "../data/AppState";
// import { addToCart, removeFromCart } from "../pages/Cart/application/cart";
import {deleteItem, getItem, getOrderItem} from "../pages/order/application/order";
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

function OrderItem({itemId, isCart = false}) {
    var [count, setCount] = useState(1);
    var [item, setItem] = useState(undefined);
    var [order, setOrder] = useState(undefined);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        getOrderItem(itemId)
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
    }, [itemId]);

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
                    <div className="h-40 w-[100%] relative">
                        <img
                            onClick={() => history.push("/item-order/" + order._id)}
                            className="h-40 w-[100%] rounded-t-lg object-cover"
                            src={item.images[0]}
                            alt=""
                        />
                        <div
                            onClick={async () => {
                                await deleteItem(itemId);
                                // window.location.reload();
                            }}
                            className="absolute top-2 right-2 ml-2 lg:ml-4 w-[40px] h-[40px] bg-red-400 flex justify-center items-center rounded-md">
                            <i className="fa-solid fa-trash text-white"></i>
                        </div>

                    </div>

                    <div className="px-4 py-2  rounded-lg ">
                        <h1 className="text-xl font-bold text-gray-700 hover:text-gray-900 hover:cursor-pointer">
                            {/*{item.item}*/}

                            {item.name}
                        </h1>
                        <div className="h-[1vh]"></div>

                        <p className="text-lg text-gray-500 hover:text-gray-900">
                            {item.farmer ? `Farmer: ` + item.farmer : `Farmer: ` + "Man Bahadur"}
                        </p>
                        <div className="flex flex-row justify-between">
                    
<div>
                        <p className="text-lg text-green-500 font-bold">
                            {` रू `+ order.price + "/" + order.quantity + order.quantityType}
                        </p>
                        </div>
                        </div>
                        <div className="flex flex-row justify-between">

                            <p className="text-lg font-bold">
                                {"Paid :  "} { order.isPaid ? <Icon
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
                    <div className="h-[1vh]"></div>
                </motion.div>
            )}
        </>
    );
}

export default OrderItem;