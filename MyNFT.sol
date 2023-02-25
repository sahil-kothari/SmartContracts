// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {

    string public myBaseURI;

    mapping (uint256 => bool) private myTokensMinted;
    uint256 private myTotalTokensMinted;

    constructor(string memory _name, string memory _symbol, string memory _baseURI) ERC721(_name, _symbol) {
        myBaseURI = _baseURI;
    }

    function createMyToken(address _to) public onlyOwner returns (uint256) {
        require(myTotalTokensMinted < 100, "Maximum number of tokens minted");
        uint256 tokenId = myTotalTokensMinted + 1;
        myTokensMinted[tokenId] = true;
        myTotalTokensMinted++;
        _safeMint(_to, tokenId);
        return tokenId;
    }

    function setMyBaseURI(string memory _newBaseURI) public onlyOwner {
        myBaseURI = _newBaseURI;
    }

    function myTokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return bytes(myBaseURI).length > 0 ? string(abi.encodePacked(myBaseURI, tokenId.toString())) : "";
    }

    function totalMyTokensMinted() public view returns (uint256) {
        return myTotalTokensMinted;
    }

    function isMyTokenMinted(uint256 tokenId) public view returns (bool) {
        return myTokensMinted[tokenId];
    }

    function burnMyToken(uint256 tokenId) public onlyOwner {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        _burn(tokenId);
        myTotalTokensMinted--;
        myTokensMinted[tokenId] = false;
    }
}