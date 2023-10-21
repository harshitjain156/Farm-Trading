import React from "react";

// Chakra imports
import { Flex, useColorModeValue } from "@chakra-ui/react";

// Custom components
import { HorizonLogo } from "./../../icons/Icons";
import { HSeparator } from "./../../separator/Separator";
import logo from "../../../assets/logo.png";

export function SidebarBrand() {
  //   Chakra color mode
  let logoColor = useColorModeValue("navy.700", "white");

  return (
    <Flex align='center' direction='column'>
        <div className="flex justify-center items-center">
          <img className="h-[120px] w-[150px]" src={logo} alt="" />
        </div>
            <span className="text-1xl font-bold mt-3 ">Farm-Trading</span>

      {/*<HorizonLogo h='26px' w='175px' my='32px' color={logoColor} />*/}
      <HSeparator mb='20px' />
    </Flex>
  );
}

export default SidebarBrand;
