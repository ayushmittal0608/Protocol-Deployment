pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../contracts/Operator.sol";
import "../lib/core/contracts/Nofeeswap.sol";

contract DeployOperator is Script {
    function run() external {
        uint256 key = vm.envUint("DEPLOYER_KEY");
        address deployer = vm.addr(key);
        vm.startBroadcast(key);

        address coreAddress = 0x017b3A3Db5f166AA564f1F154E6034685eFA08CC;
        address permit2 = 0x610178dA211FEF7D417bC0e6FeD39F05609AD788;
        address weth9 = 0xB7f8BC63BbcaD18155201308C8f3540b07f84F5e;

        address quoter = address(0);
        Operator operator = new Operator(coreAddress, permit2, weth9, quoter);
        console.log("Operator deployed at:", address(operator));

        vm.stopBroadcast();
    }
}