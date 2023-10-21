import React from "react";
import {Route, HashRouter, Switch} from "react-router-dom";
// import About from "./pages/About/presentation/About";
import "@fortawesome/fontawesome-free/css/all.css";

import "react-toastify/dist/ReactToastify.css";
import Search from "./pages/Search/presentation/Search";
import AdminLayout from "./navigations/admin";
import ShopLayout from "./navigations/shop";
import UsersLayout from "./navigations/users";
import OrderLayout from "./navigations/order";
import LoginLayout from "./navigations/login";
import ProfileLayout from "./navigations/profile";
import Login from "./pages/Login/presentation/Login.jsx";
import "./../src/assets/css/App.css";
import "./index.css";
import {ChakraProvider} from "@chakra-ui/react";
import theme from "./theme/theme";
import {ThemeEditorProvider} from "@hypertheme-editor/chakra-ui";
import ReactDOM from 'react-dom';
import ItemDetail from "./pages/shop/presentation/ItemDetail.jsx";
import ItemOrderDetail from "./pages/order/presentation/ItemDetail.jsx";

ReactDOM.render(
    <ChakraProvider theme={theme}>
        <React.StrictMode>
            <ThemeEditorProvider>
                <HashRouter>
                    <Switch>
                        <Route path="/" exact component={Login}/>
                        <Route path="/shop" component={ShopLayout}/>
                        <Route path="/users" component={UsersLayout}/>
                        <Route path="/order" component={OrderLayout}/>
                        <Route path="/login" component={LoginLayout}/>
                        <Route path="/profile" component={ProfileLayout}/>
                        <Route path="/search" component={Search}/>
                        <Route path="/admin" component={AdminLayout}/>
                        <Route path="/item/:id" component={ItemDetail} />
                        <Route path="/item-order/:id" component={ItemOrderDetail} />
                    </Switch>
                </HashRouter>
            </ThemeEditorProvider>
        </React.StrictMode>
    </ChakraProvider>,
    document.getElementById('root')
);
