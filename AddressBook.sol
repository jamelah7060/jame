// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    string public salt = "vrt"; 
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    Contact[] private contacts;
    mapping(uint => Contact) private idToContact;

    event ContactAdded(uint indexed id, string firstName, string lastName, uint[] phoneNumbers);
    event ContactDeleted(uint indexed id);

    error ContactNotFound(uint id);

    constructor() Ownable() {}

    function addContact(string calldata firstName, string calldata lastName, uint[] calldata phoneNumbers) external onlyOwner {
        uint id = contacts.length + 1;
        Contact memory newContact = Contact(id, firstName, lastName, phoneNumbers);
        contacts.push(newContact);
        idToContact[id] = newContact;
        emit ContactAdded(id, firstName, lastName, phoneNumbers);
    }

    function deleteContact(uint id) external onlyOwner {
        require(id <= contacts.length, "Contact not found");
        delete idToContact[id];
        emit ContactDeleted(id);
    }

    function getContact(uint id) external view returns (Contact memory) {
        Contact memory contact = idToContact[id];
        if (contact.id == 0) revert ContactNotFound(id);
        return contact;
    }

    function getAllContacts() external view returns (Contact[] memory) {
        return contacts;
    }
}
