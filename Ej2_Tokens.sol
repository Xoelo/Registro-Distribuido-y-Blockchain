
 // SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

contract TokenContract {
    address public owner;

    uint256 public constant TOKEN_PRICE = 5 ether;

    struct Receivers {
        string name;
        uint256 tokens;
    }

    mapping(address => Receivers) public users;

    event TokensPurchased(
        address indexed buyer,
        uint256 amount,
        uint256 etherPaid
    );

    event TokensTransferred(
        address indexed from,
        address indexed to,
        uint256 amount
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        users[owner].tokens = 100;
    }

    function double(uint256 _value)
        public
        pure
        returns (uint256)
    {
        return _value * 2;
    }

    function register(string memory _name) public {
        users[msg.sender].name = _name;
    }

    function giveToken(
        address _receiver,
        uint256 _amount
    ) public onlyOwner {
        require(_receiver != address(0), "Invalid receiver");
        require(
            users[owner].tokens >= _amount,
            "Insufficient owner tokens"
        );

        users[owner].tokens -= _amount;
        users[_receiver].tokens += _amount;

        emit TokensTransferred(owner, _receiver, _amount);
    }

    function buyToken(uint256 _amount) public payable {
        require(_amount > 0, "Amount must be greater than zero");

        require(
            msg.value >= _amount * TOKEN_PRICE,
            "Insufficient Ether sent"
        );

        require(
            users[owner].tokens >= _amount,
            "Not enough tokens available"
        );

        users[owner].tokens -= _amount;
        users[msg.sender].tokens += _amount;

        emit TokensPurchased(msg.sender, _amount, msg.value);
    }

    function getContractBalance()
        public
        view
        returns (uint256)
    {
        return address(this).balance;
    }
}

