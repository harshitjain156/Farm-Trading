import { useHistory, useParams } from "react-router-dom";
import { addComment, getItem } from "../application/shop";
import React, { useEffect, useState } from "react";
import NavBar from "../../../components/NavBar";
import Loading from "../../../components/Loading";
import Rating from "react-rating";
import "@fortawesome/fontawesome-free/css/all.css";

import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
function ItemDetail() {
  const { id } = useParams();
  const [item, setItem] = useState({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    getItem(id).then((item) => {
      setLoading(false);
      console.log(item);
      console.log('------------');
      setItem(item);
    });

    return () => {
      // Cleanup
    };
  }, []);

  return (
    <>
      {/* <NavBar /> */}
      {loading ? <Loading /> : <LoadedPage item={item} />}
    </>
  );
}

function LoadedPage({ item }) {
  const [comment, setComment] = useState("");
  const history = useHistory();

  return (
    <>

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
            <div className="flex flex-row items-end">
              <h1 className="pb-0 text-4xl font-bold text-accentColor">
                {`रू ` + item.price}
              </h1>
            </div>

            <p className="text-lg"> Description: {item.description}</p>
          </div>
        </div>
      </section>
      {/* Comments Section */}
      <div className="flex flex-col md:flex-row mt-5   h-[8vh] mx-5 md:mx-12">
      </div>
      {/*{item.comments}*/}
      {item.comments && (

        <section className="px-5 md:px-12 mb-5 md:mb-12">
          {item.comments.map((comment) => (
            // <p key={comment._id}>{comment.content}</p>
            <div
              key={comment._id}
              className="flex flex-row pt-4 pb-2 border-b border-slate-200"
            >
              <div className="h-[25px] w-[25px] text-white p-4 rounded-full bg-lightColor flex justify-center items-center">
                <p className="">{comment.name[0]}</p>
              </div>
              <div className="flex flex-col pl-2">
                <h1 className="text-xl">{comment.content}</h1>
                <p className="text-slate-400">{comment.name}</p>
              </div>
            </div>
          ))}
        </section>
      )}
    </>
  );
}

export default ItemDetail;
