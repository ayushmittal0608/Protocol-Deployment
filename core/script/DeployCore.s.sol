pragma solidity ^0.8.28;
import "forge-std/Script.sol";
import "../contracts/Nofeeswap.sol";
import "../contracts/NofeeswapDelegatee.sol";
import "../contracts/MockERC20.sol";
import "../contracts/helpers/DeployerHelper.sol";
import "../contracts/utilities/Tag.sol";
import "../contracts/utilities/X47.sol";

contract DeployCore is Script {
    function run() external {
        uint256 key = vm.envUint("DEPLOYER_KEY");
        address deployer = vm.addr(key);
        vm.startBroadcast(key);

        address admin = deployer;

        DeployerHelper deployerHelper = new DeployerHelper(admin);
        bytes32 delegateeSalt = bytes32(uint256(1));
        bytes32 nofeeswapSalt = bytes32(uint256(2));

        address delegateeAddr = deployerHelper.addressOf(delegateeSalt);
        address nofeeswapAddr = deployerHelper.addressOf(nofeeswapSalt);

        deployerHelper.create3(
            delegateeSalt,
            abi.encodePacked(
                type(NofeeswapDelegatee).creationCode,
                abi.encode(nofeeswapAddr)
            )
        );
        deployerHelper.create3(
            nofeeswapSalt,
            abi.encodePacked(
                type(Nofeeswap).creationCode,
                abi.encode(delegateeAddr, admin)
            )
        );

        Nofeeswap nofeeswap = Nofeeswap(nofeeswapAddr);
        NofeeswapDelegatee delegatee = NofeeswapDelegatee(delegateeAddr);

        uint256 initialMint = 1_000_000 * 1e18; 
        MockERC20 token0=new MockERC20("Token0", "T0");
        MockERC20 token1=new MockERC20("Token1", "T1");
        address _token0=address(token0);
        address _token1=address(token1);

        token0.mint(deployer, initialMint);
        token1.mint(deployer, initialMint);

        if(_token0>_token1){
            (_token0, _token1)=(_token1, _token0);
        }
        Tag tag0 = TagLibrary.tag(_token0);
        Tag tag1 = TagLibrary.tag(_token1);

        int8 logOffset = 0;
        uint256 flags = 0;
        address hook = address(0);
        uint256 unsaltedPoolId =
            (uint256(uint8(logOffset)) << 180) |
            (flags << 160) |
            uint160(hook);
        X47 poolGrowthPortion = X47.wrap(0x800000000000);

        uint256[] memory kernelCompactArray = new uint256[](1);
        kernelCompactArray[0] = 0x8000000001000000000000000000000000000000000000000000000000000000;
        uint256[] memory curveArray = new uint256[](1);
        curveArray[0] = 0x0800000000000000080001000000000008000080000000000000000000000000;
        bytes memory hookData = "";

        bytes memory data = abi.encodeCall(
            delegatee.initialize,
            (
                unsaltedPoolId,
                tag0,
                tag1,
                poolGrowthPortion,
                kernelCompactArray,
                curveArray,
                hookData
            )
        );

        

        console.log("Nofeeswap core:", address(nofeeswap));
        console.log("Mock Token0:", address(token0));
        console.log("Mock Token1:", address(token1));

        nofeeswap.dispatch(data);
        vm.stopBroadcast();
    }
}
