import NavBar from "../../../components/NavBar";
import { useHistory } from "react-router-dom";
import appState from "../../../../src/data/AppState";

function Profile() {
  var user = appState.getUserData();
  console.log(user);
  const history = useHistory();


  return (
    <>
      {/*<NavBar />*/}
      <section className="h-screen mt-[8vh] flex flex-col justify-center items-center bg-accentColor bg-opacity-10">
        {user._id !== undefined ? (
          <>
            <h1 className="text-3xl font-bold">{user.name}</h1>
            <h1 className="text-slate-700">{user.email}</h1>
            <h1>{`${user.phone}`}</h1>
            <p className="mt-5 bg-lightColor font-semibold tracking-  text-white px-5 py-2 rounded-md">{`Access Level: ${
              user.userType ?? "".toUpperCase()
            }`}</p>

            <button
              className="mt-5 bg-red-600 font-semibold tracking-  text-white px-5 py-2 rounded-md"
              onClick={() => {
                appState.logOutUser();
                history.push("/");
              }}
            >
              <i className="fa-solid fa-right-from-bracket pr-2"></i>
              Logout
            </button>
          </>
        ) : (
          <>
            <h1>Currently not logged in</h1>
            <button
              onClick={async () => {
                history.push("/");
              }}
              className="bg-lightColor  rounded-lg text-white font-semibold text-md  py-2 px-10 mt-5"
            >
              Login
            </button>
          </>
        )}
      </section>
    </>
  );
}

export default Profile;
