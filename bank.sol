// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BankAccount {
    address public owner;
    mapping(address => uint256) private balances;
    
    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);
    
    // Custom errors
    error InsufficientBalance(uint256 requested, uint256 available);
    error NotAccountOwner(address caller);
    error InvalidAmount();
    error TransferFailed();
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotAccountOwner(msg.sender);
        }
        _;
    }
    
    modifier validAmount(uint256 _amount) {
        if (_amount <= 0) {
            revert InvalidAmount();
        }
        _;
    }
    
    // Function to deposit money into the account
    function deposit() public payable validAmount(msg.value) {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    
    // Updated withdraw function with better security
    function withdraw(uint256 _amount) public validAmount(_amount) {
        // Check if user has sufficient balance
        uint256 userBalance = balances[msg.sender];
        if (_amount > userBalance) {
            revert InsufficientBalance(_amount, userBalance);
        }
        
        // Update balance before transfer to prevent reentrancy
        balances[msg.sender] -= _amount;
        
        // Transfer the amount
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        if (!success) {
            // If transfer fails, revert the balance change
            balances[msg.sender] += _amount;
            revert TransferFailed();
        }
        
        emit Withdrawal(msg.sender, _amount);
    }
    
    // Function to check caller's balance
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
    
    // Function to get contract's total balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    // Function to receive Ether
    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    
    // Fallback function
    fallback() external payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
}