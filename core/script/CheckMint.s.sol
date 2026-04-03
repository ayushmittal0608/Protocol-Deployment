pragma solidity ^0.8.28;
import "forge-std/Script.sol";
import "../contracts/MockERC20.sol";

contract CheckMint is Script {
    function run() external {
        address token0Addr = 0x9E545E3C0baAB3E08CdfD552C960A1050f373042
        address token1Addr = 0xa82fF9aFd8f496c3d6ac40E2a0F282E47488CFc9;
        address deployer = vm.addr(vm.envUint("DEPLOYER_KEY"));

        MockERC20 token0 = MockERC20(token0Addr);
        MockERC20 token1 = MockERC20(token1Addr);

        console.log("Deployer Token0 balance:", token0.balanceOf(deployer));
        console.log("Deployer Token1 balance:", token1.balanceOf(deployer));
    }
}