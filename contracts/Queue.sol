pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 size = 5;
	// YOUR CODE HERE
	address[] buyers;
	uint8 pplInQ;
	uint timeLimit;
	mapping (address => uint) timeInQ;

	/* Add events */
	// YOUR CODE HERE

	/* Add constructor */
	function Queue(uint _timeLimit) public {
		timeLimit = _timeLimit;
		buyers = new address[](size);
		pplInQ = 0;
	}
	// YOUR CODE HERE

	/* Returns the number of people waiting in line */
	function qsize() constant public returns(uint8) {
		// YOUR CODE HERE
		return pplInQ;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant public returns(bool) {
		// YOUR CODE HERE
		return pplInQ == 0;
	}
	
	/* Returns the address of the person in the front of the queue */
	function getFirst() constant public returns(address) {
		// YOUR CODE HERE
		if (buyers[0] != 0) {
			return buyers[0];
		}
	}
	
	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant public returns(uint8) {
		// YOUR CODE HERE
		for (uint8 i = 0; i <= size; i++) {
			if (buyers[i] == msg.sender) {
				return i;
			}
			// return not in Q
		}
	}
	
	event TimesUp(address buyer, uint time);

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() public {
		// YOUR CODE HERE
		address firstPerson = buyers[0];
		if (block.timestamp - timeInQ[firstPerson] > timeLimit) {
			TimesUp(firstPerson, block.timestamp);
			dequeue();
		}
	}
	
	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() public {
		// YOUR CODE HERE
		pplInQ -= 1;
		buyers[0] = 0;
		address[] memory newBuyers = new address[](size);
		uint j = 0;

		for (uint i = 0; i <= size; i++) {
			if (buyers[i] != 0) {
				newBuyers[j] = buyers[i];
				j += 1;
			}
		}

		for (uint k = 0; k <= size; k++) {
			buyers[k] = newBuyers[k];
		}
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) public {
		// YOUR CODE HERE
		if (pplInQ <= 5) {
			pplInQ += 1;
			timeInQ[addr] = block.timestamp;

			for (uint i = 0; i <= size; i++) {
				if (buyers[i] == 0) {
					buyers[i] = addr;
					break;
				}
			}
		}
	}


}
