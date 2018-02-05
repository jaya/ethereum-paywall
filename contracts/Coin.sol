pragma solidity ^0.4.18;

contract Coin {

    mapping (address => uint) balances;
    address owner;

    function Coin() public {
        owner = msg.sender;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function burn(address user, uint amount) public {
        require(msg.sender == owner);
        balances[user] -= amount;
    }

    function balanceOf(address user) public view returns (uint balance) {
        return balances[user];
    }

}
