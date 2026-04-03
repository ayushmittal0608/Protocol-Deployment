pragma solidity ^0.8.20;
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    address public owner;
    constructor(string memory name, string memory symbol) ERC20(name, symbol)
    {   
        owner = msg.sender;
        _mint(owner, 1_000_000 * 1e18);
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "Only owner can mint");
        _mint(to, amount);
    }

}