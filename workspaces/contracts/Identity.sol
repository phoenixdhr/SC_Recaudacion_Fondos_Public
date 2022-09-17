

// SPDX-License-Identifier: MIT


pragma solidity >=0.7.0 <0.9.0;

contract Identity {
    uint public idNumber;
    bool public isWorking;
    string public name;
    address public wallet;

        constructor(uint _idNumber, bool _isworking, string memory _name ) {
            idNumber=_idNumber;
            isWorking=_isworking;
            name=_name;
            wallet=msg.sender;   
        }
    
}