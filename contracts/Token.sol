pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	// YOUR CODE HERE
	string public constant NAME = "New Innovative Coin Konglomerate";
    string public constant SYMBOL = "NICK";
    uint8 public constant DECIMALS = 18;

	uint256 public totalSupply;
    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

	function Token(uint _totalSupply) public {
		totalSupply = _totalSupply;
		// initialize s.t. owner owns all the coins and disperses from his wallet
		balances[msg.sender] = totalSupply;
	}

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) constant public returns (uint256 balance) {
		return balances[_owner];
	}

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success) {
		if (balances[msg.sender] - _value > 0) {
			balances[msg.sender] -= _value;
			balances[_to] += _value;
			Transfer(msg.sender, _to, _value);
			return true;
		} else {
			return false;
		}
		
	}

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		if (balances[_to] - _value > 0) {
			balances[_from] -= _value;
			balances[_to] += _value;
			Transfer(_from, _to, _value);
		}
		return true;
	}

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
		return allowed[_owner][_spender];
	}

	function burn(uint256 _value) public returns (bool success) {
		if (_value < balances[msg.sender]) {
			totalSupply -= _value;
			balances[msg.sender] -= _value;
			Burn(msg.sender, _value);
			return true;
		}
		return false;
	}

	// should this be here??
	function mint(uint256 _value) public returns (bool success) {
		totalSupply += _value;
		balances[msg.sender] += _value;
		return true;
	}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	event Burn(address _burner, uint256 _burnedAmount);
}
