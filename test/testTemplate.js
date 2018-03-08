'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Queue = artifacts.require("./Queue.sol");
const Token = artifacts.require("./Token.sol")
// YOUR CODE HERE

contract('testTemplate', function(accounts) {
	/* Define your constant variables and instantiate constantly changing 
	 * ones
	 */
	const args = {_totalSupply = 10, _saleTime = 5, _tokenValue = 1,
		_smallPurchase = 1, _medPurchase = 3, _bigPurchase = 5};
	let launchNick, owner, buyerOne, buyerTwo, buyerThree, buyerFour;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		// YOUR CODE HERE
		/* Launches a new ICO with the standard token value, sale time, and a limited supply of tokens. */ 
		launchNick = await Crowdsale.new({value: _tokenValue, _saleTime, _totalSupply});
		});

	/* Group test cases together 
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Crowdsale Works', function() {
		it("Buyers can purchase a specified amount of tokens from the ICO owner", async function() {
			// YOUR CODE HERE
			let buyerOne = await Queue.enqueue(buyerOne);
			let buyerTwo = await Queue.enqueue(buyerTwo);
			let buyerThree = await Queue.enqueue(buyerThree);

			let buyerOne = await Crowdsale.buy(_smallPurchase);
			await Token.balanceOf(buyerOne);
			let buyerTwo = await Crowdsale.buy(_smallPurchase);
			await Token.balanceOf(buyerTwo);
		});
		it("Buyers can use tokens in transactions.", async function() {
			// YOUR CODE HERE
			let buyerOne = Token.transferTo(buyerTwo, 1);
			assert.equal(Token.balanceOf(balanceTwo), 6);
			let buyerTwo = Token.transferTo(buyerOne, 6);
			assert.equal(Token.balanceOf(balanceOne), 6);
		});
		// YOUR CODE HERE
	});

	describe('Your string here', function() {
		// YOUR CODE HERE
	});
});
