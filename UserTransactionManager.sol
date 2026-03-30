// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UserTransactionManager {
    struct User {
        string name;
        bool exists;
        uint256 createdAt;
    }

    struct UserTransaction {
        address from;
        address to;
        uint256 amount;
        uint256 timestamp;
        string action;
    }

    address public owner;

    mapping(address => User) private users;
    mapping(address => UserTransaction[]) private userTransactions;
    address[] private userList;

    event UserAdded(address indexed userAddress, string name);
    event UserDeleted(address indexed userAddress);
    event UserStored(address indexed userAddress, string name);
    event UserTransactionRecorded(
        address indexed userAddress,
        address indexed from,
        address indexed to,
        uint256 amount,
        string action,
        uint256 timestamp
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyExistingUser(address userAddress) {
        require(users[userAddress].exists, "User does not exist");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Adds a new user to the on-chain local database.
    function addUser(address userAddress, string calldata name) external onlyOwner {
        require(userAddress != address(0), "Invalid user address");
        require(!users[userAddress].exists, "User already exists");

        users[userAddress] = User({
            name: name,
            exists: true,
            createdAt: block.timestamp
        });
        userList.push(userAddress);

        emit UserAdded(userAddress, name);
    }

    // Stores or updates a user record in the on-chain local database.
    function storeUser(address userAddress, string calldata name) external onlyOwner {
        require(userAddress != address(0), "Invalid user address");

        if (!users[userAddress].exists) {
            userList.push(userAddress);
            users[userAddress].createdAt = block.timestamp;
            users[userAddress].exists = true;
        }

        users[userAddress].name = name;

        emit UserStored(userAddress, name);
    }

    function deleteUser(address userAddress) external onlyOwner onlyExistingUser(userAddress) {
        delete users[userAddress];
        delete userTransactions[userAddress];

        uint256 length = userList.length;
        for (uint256 i = 0; i < length; i++) {
            if (userList[i] == userAddress) {
                userList[i] = userList[length - 1];
                userList.pop();
                break;
            }
        }

        emit UserDeleted(userAddress);
    }

    function recordUserTransaction(
        address userAddress,
        address from,
        address to,
        uint256 amount,
        string calldata action
    ) external onlyOwner onlyExistingUser(userAddress) {
        require(from != address(0), "Invalid sender address");
        require(to != address(0), "Invalid receiver address");
        require(amount > 0, "Amount must be greater than zero");

        UserTransaction memory txRecord = UserTransaction({
            from: from,
            to: to,
            amount: amount,
            timestamp: block.timestamp,
            action: action
        });

        userTransactions[userAddress].push(txRecord);

        emit UserTransactionRecorded(userAddress, from, to, amount, action, block.timestamp);
    }

    function getUser(
        address userAddress
    )
        external
        view
        onlyExistingUser(userAddress)
        returns (string memory name, bool exists, uint256 createdAt, uint256 transactionCount)
    {
        User memory user = users[userAddress];
        return (user.name, user.exists, user.createdAt, userTransactions[userAddress].length);
    }

    function viewUserTransactions(
        address userAddress
    ) external view onlyExistingUser(userAddress) returns (UserTransaction[] memory) {
        return userTransactions[userAddress];
    }

    function getUserTransactionCount(address userAddress) external view onlyExistingUser(userAddress) returns (uint256) {
        return userTransactions[userAddress].length;
    }

    function getAllUsers() external view returns (address[] memory) {
        return userList;
    }
}
