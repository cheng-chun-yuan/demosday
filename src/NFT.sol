// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721 {

    uint256 public tokenId = 0;
    uint256 _tokenPrices;
    address private owner;
    mapping (uint256 => string) private _tokenURIs;
    event URI(string uri, uint256 indexed tokenId);
    event Refund(uint256 _tokenId,uint256 refundAmount);  
    uint256 public _maxSupply;
    uint256 private _tokenPrice;
    uint256 public nextSaleNumber;

    constructor(
        string memory name,
        string memory symbol,
        uint256 maxSupply,
        uint256 tokenPrice
        
    ) ERC721(name, symbol) {
        _maxSupply = maxSupply;
        _tokenPrices = tokenPrice;
        owner = msg.sender;
    }

    function mintNFT(string memory _tokenURI) public payable returns (uint256) {
        require(msg.value >= _tokenPrices, "Insufficient funds");
        require(_maxSupply > tokenId,"out of stock");
        tokenId++;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        return tokenId;
    }

    function _setTokenURI(uint256 _tokenId, string memory uri) internal virtual {
        require(_exists(_tokenId), "URI set of nonexistent token");
        _tokenURIs[_tokenId] = uri;
        emit URI(uri, _tokenId);
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        require(_exists(_tokenId), "URI query for nonexistent token");
        return _tokenURIs[_tokenId];
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the contract owner can withdraw");
        payable(msg.sender).transfer(address(this).balance);
    }

    function refund(uint256 _tokenId) external payable {
        require(_exists(_tokenId), "ERC721A: nonexistent token");
        require(msg.sender == ownerOf(_tokenId), "ERC721A: only token owner can request refund");

        uint256 refundAmount = _tokenPrices * 9 / 10;

        // 确保项目方已经向合约转移了足够的以太币来支付退款
        //ghow to cheak the owner balance?
        require(address(this).balance >= refundAmount, "ERC721A: insufficient funds for refund");
        // 销毁 NFT
        _burn(_tokenId);
        nextSaleNumber++;
        // 发送退款给申请者
        payable(msg.sender).transfer(refundAmount);
        emit Refund(_tokenId, refundAmount);
    }

}
