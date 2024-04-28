// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable(msg.sender) {
    string public salt = "vrt"; 
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    Contact[] private contacts;
    mapping(uint => uint) private idToIndex;
    uint private nextId = 1;

    event ContactAdded(uint indexed id, string firstName, string lastName, uint[] phoneNumbers);
    event ContactDeleted(uint indexed id);

    error ContactNotFound(uint id);

    function addContact(string calldata firstName, string calldata lastName, uint[] calldata phoneNumbers) external onlyOwner {
        contacts.push(Contact(nextId, firstName, lastName, phoneNumbers));
        idToIndex[nextId] = contacts.length;
        emit ContactAdded(nextId, firstName, lastName, phoneNumbers);
        nextId++;
    }

    function deleteContact(uint id) external onlyOwner {
        uint index = idToIndex[id];
        if (index == 0 || index > contacts.length || contacts[index - 1].id != id) revert ContactNotFound(id);

        emit ContactDeleted(id);

        uint lastIndex = contacts.length - 1;
        if (index != contacts.length) {
            contacts[index - 1] = contacts[lastIndex];
            idToIndex[contacts[index - 1].id] = index;
        }
        contacts.pop();
        delete idToIndex[id];
    }

    function getContact(uint id) external view returns (Contact memory) {
        uint index = idToIndex[id];
        if (index == 0 || index > contacts.length || contacts[index - 1].id != id) revert ContactNotFound(id);
        return contacts[index - 1];
    }

    function getAllContacts() external view returns (Contact[] memory) {
        return contacts;
    }
}
