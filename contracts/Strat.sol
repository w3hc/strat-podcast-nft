// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/draft-ERC721Votes.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

interface ISubscriptionOwner {
    function getSubscriptionOwner() external view returns (address);
}

contract Strat is
    ERC165,
    ERC721,
    ISubscriptionOwner,
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Burnable,
    Ownable,
    EIP712,
    ERC721Votes,
    ReentrancyGuard
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    string public uri;

    constructor(string memory _uri) ERC721("StratTest", "STRAT") EIP712("StratTest", "1") {
        uri = _uri;
    }

    function safeMint() public nonReentrant {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Votes) {
        super._afterTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable, ERC721URIStorage, ERC165) returns (bool) {
        return
            interfaceId == type(ISubscriptionOwner).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function getSubscriptionOwner() external view returns (address) {
        return owner();
    }
}
