import { useHistory } from "react-router-dom";

function Button({ text = "Button", additionalClasses = "", path = "/" }) {
  var history = useHistory();

  return (
    <button
      onClick={() => {
        history.push(path);
      }}
      className={`bg-green-500 hover:bg-opacity-80 text-sm md:text-lg lg:text-lg rounded-md py-3 px-4 text-white ${additionalClasses}`}
    >
      {text}
    </button>
  );
}

export default Button;
