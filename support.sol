// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarketplace is Ownable {
    address payable public immutable feeAccount;
    uint256 public feePercent = 10; // 10% fee
}
    struct Listing {
        uint256 price;
        address owner;
  

    mapping(uint256 => Listing) public  listings;

    event NFTListed(address indexed owner, uint256 indexed tokenId, uint256 price);
    event NFTPurchased(address indexed buyer, address indexed seller, uint256 indexed tokenId, uint256 price);

    constructor(address payable _feeAccount) {
        feeAccount = _feeAccount;
    }
    }
    function listNFT(uint256 _tokenId, uint256 _price) public {
        ERC721 nftContract = ERC721(msg.sender);
        require(nftContract.ownerOf(_tokenId) == msg.sender, "Not the owner");
        require(_price > 0, "Price must be greater than zero");

        listings[_tokenId] = Listing(_price, msg.sender);

        emit NFTListed(msg.sender, _tokenId, _price);
    }

    function buyNFT(uint256 _tokenId) public payable {
        Listing memory listing = listings[_tokenId];
        require(listing.price == msg.value, "Incorrect price");

        ERC721 nftContract = ERC721(msg.sender);
        nftContract.safeTransferFrom(listing.owner, msg.sender, _tokenId);

        uint256 feeAmount = (msg.value * feePercent) / 100;
        feeAccount.transfer(feeAmount);
        listing.owner.transfer(msg.value - feeAmount);

      delete listings[_tokenId];

        emit NFTPurchased(msg.sender, listing.owner, _tokenId, msg.value);
    }

    function setFeePercent(uint256 _feePercent) public onlyOwner {
        feePercent = _feePercent;
    }

