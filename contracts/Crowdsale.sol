pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
	// YOUR CODE HERE
	address public owner;
	uint256 public startTime;
	uint256 public endTime;

	uint256 public totalSupply;
	uint256 public tokensSold;
	uint256 public tokenValue;
	uint256 public ownerEth;

	Queue public buyersWaiting;
	mapping (address => uint256) balance;
	Token public nick;

	function Crowdsale(uint256 _totalSupply, uint256 _saleTime, uint256 _tokenValue) public {
		owner = msg.sender;
		startTime = block.timestamp;
		endTime = startTime + _saleTime;

		totalSupply = _totalSupply;
		tokenValue = _tokenValue;
		tokensSold = 0;
		ownerEth = 0;

		buyersWaiting = new Queue(_saleTime);
		nick = new Token(_totalSupply);
	}


	function timeRemaining() public view returns (uint256) {
		return endTime - block.timestamp;
	}

	modifier ownerOnly() {
		require(msg.sender == owner);
		_;
	}

	function mint(uint256 _amount) private ownerOnly() {
		totalSupply += _amount;
		nick.mint(_amount);
	}

	function burn(uint256 _amount) private ownerOnly() returns (bool success) {
		if (totalSupply - tokensSold > _amount) {
			nick.burn(_amount);
			totalSupply -= _amount;
			return true;
		} else {
			return false;
		}
	}

	function buy() public payable returns (bool success) {
		if (buyersWaiting.getFirst() == msg.sender && buyersWaiting.qsize() > 1 && now > startTime && now < endTime) {
			uint256 ethSent = msg.value;
			ownerEth += ethSent;
			uint256 amountOfNick = tokenValue / ethSent;

			if (tokensSold + amountOfNick < totalSupply) {
				tokensSold += amountOfNick;
				nick.transferFrom(owner, msg.sender, amountOfNick);
				buyersWaiting.dequeue();
				return true;
			} else {
				revert();
				return false;
			}
		} else {
			return false;
		}
	}
}

// Owner:
// - Must be set on deployment X
// - Must be able to time-cap the sale X
// - Must keep track of start-time X
// 		- Must keep track of end-time/time remaining since start-time X 
// 		- Must be able to specify an initial amount of tokens to create X
// - Must be able to specify the amount of tokens 1 wei is worth X
// - Must be able to mint new tokens X
// 		- This amount would be added to totalSupply in Token.sol X
// - Must be able to burn tokens not sold yet X
// 		- This amount would be subtracted from totalSupply in Token.sol X
// - Must be able to receive funds from contract after the sale is over 

// Buyers:
// - Must be able to buy tokens directly from the contract and as long as the sale has not ended, if they are first in the queue and there is someone waiting line behind them
// 		- This would change their balance in Token.sol
// 		- This would change the number of tokens sold
// - Must be able to refund their tokens as long as the sale has not ended. Their place in the queue does not matter
// 		- This would change their balance in Token.sol
// 		- This would change the number of tokens sold
