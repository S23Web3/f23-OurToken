// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ManualToken {
    event Transferred(address indexed _from, address indexed _to, uint256 _value);

    mapping(address => uint256) private s_balances;
    //holding some tokens means to have a balance in this mapping

    function name() public pure returns (string memory) {
        return "Manual Token";
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    //balanceOf gets the details of the address to its balance from the mapping
    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _amount) public returns (bool success) {
        address _from = msg.sender;
        uint256 previousBalances = balanceOf(_from) + balanceOf(_to);
        s_balances[_from] -= _amount;
        s_balances[_to] += _amount;
        require(balanceOf(_from) + balanceOf(_to) == previousBalances);
        emit Transferred(_from, _to, _amount);
        return true;
    }
}
