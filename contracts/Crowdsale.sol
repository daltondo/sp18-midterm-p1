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

	function buy(uint256 _amount) public payable returns (bool success) {
		if (buyersWaiting.getFirst() == msg.sender && buyersWaiting.qsize() > 1 && now > startTime && now < endTime) {
			uint256 ethSent = msg.value;
			ownerEth += ethSent;
			uint256 amountOfNick = tokenValue / ethSent;

			if (tokensSold + amountOfNick < totalSupply && amountOfNick == _amount) {
				tokensSold += amountOfNick;
				nick.transferFrom(owner, msg.sender, amountOfNick);
				Purchase(msg.sender, amountOfNick, block.timestamp);
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

	function refund(uint256 _amount) public payable returns (bool success) {
		uint256 ethSent = msg.value;
		ownerEth += ethSent;
		uint256 amountOfNick = tokenValue / ethSent;

		if (nick.balanceOf(msg.sender) >= amountOfNick && amountOfNick == _amount) {
			tokensSold -= amountOfNick;
			nick.transferFrom(msg.sender, owner, amountOfNick);
			Refund(msg.sender, amountOfNick, block.timestamp);
			return true;
		} else {
			revert();
			return false;
		}
	}

	event Purchase(address buyer, uint256 _amount, uint256 _timeOfPurchase);
	event Refund(address refunder, uint256 _amount, uint256 _timeOfRefund);
}