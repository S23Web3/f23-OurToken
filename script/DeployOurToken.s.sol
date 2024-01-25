//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {OurToken} from "../src/OurToken.sol";

contract DeployOurToken is Script {
    //using the environment variable, there should be a deployerkey
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (OurToken) {
        vm.startBroadcast();
        OurToken ourToken = new OurToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return ourToken;
    }
}
