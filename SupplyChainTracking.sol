// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    struct Item {
        uint256 id;
        string name;
        address owner;
        bool exists;
    }

    mapping(uint256 => Item) public items;
    uint256 public itemCount;

    event ItemAdded(uint256 indexed id, string name, address indexed owner);

    function addItem(string memory _name) public {
        uint256 id = itemCount++;
        items[id] = Item({
            id: id,
            name: _name,
            owner: msg.sender,
            exists: true
        });
        emit ItemAdded(id, _name, msg.sender);
    }
}
