// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {ERC721O} from "src/ERC721O.sol";

contract MockERC721 is ERC721O {
    constructor(string memory _name, string memory _symbol) ERC721O(_name, _symbol) {}

    function tokenURI(uint256) public pure virtual override returns (string memory) {}

    function mint(address to, uint256 tokenId) public virtual {
        _mint(to, tokenId);
    }

    function burn(uint256 tokenId) public virtual {
        _burn(tokenId);
    }

    function safeMint(address to, uint256 tokenId) public virtual {
        _safeMint(to, tokenId);
    }

    function safeMint(address to, uint256 tokenId, bytes memory data) public virtual {
        _safeMint(to, tokenId, data);
    }

    /// ERC721O specific, example implementation

    // example
    struct info {
        address owner;
        uint96 otherThing;
    }

    // example
    mapping(uint256 => info) internal _info;

    // do not have to override, included as example
    function _mint(address to, uint256 id) internal virtual override {
        // maybe some ID specific trait tracking
        _info[id].otherThing = uint96(block.difficulty % (2 << 96));

        super._mint(to, id);
    }

    function _getOwnerOf(uint256 id) internal view virtual override returns (address) {
        return _info[id].owner;
    }

    function _setOwnerOf(uint256 id, address owner) internal virtual override {
        if (owner == address(0)) {
            delete _info[id];
        } else {
            _info[id].owner = owner;
        }
    }
}
