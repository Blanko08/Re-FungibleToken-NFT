// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

// Imports
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

contract NFT is ERC721 {
    // Constructor
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
    }

    // Funciones
    function mint(address _to, uint _tokenId) external {
        _mint(_to, _tokenId);
    }
}