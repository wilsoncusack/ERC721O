// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {ERC721} from "solmate/tokens/ERC721.sol";

abstract contract ERC721O is ERC721 {
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    /// OVERRIDEN SOLMATE FUNCTIONS ///

    function ownerOf(uint256 id) public view virtual override returns (address owner) {
        require((owner = _getOwnerOf(id)) != address(0), "NOT_MINTED");
    }

    function approve(address spender, uint256 id) public virtual override {
        address owner = _getOwnerOf(id);

        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");

        getApproved[id] = spender;

        emit Approval(owner, spender, id);
    }

    function transferFrom(address from, address to, uint256 id) public virtual override {
        require(from == _getOwnerOf(id), "WRONG_FROM");

        require(to != address(0), "INVALID_RECIPIENT");

        require(
            msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[id], "NOT_AUTHORIZED"
        );

        // Underflow of the sender's balance is impossible because we check for
        // ownership above and the recipient's balance can't realistically overflow.
        unchecked {
            _balanceOf[from]--;

            _balanceOf[to]++;
        }

        _setOwnerOf(id, to);

        delete getApproved[id];

        emit Transfer(from, to, id);
    }

    function _mint(address to, uint256 id) internal virtual override {
        require(to != address(0), "INVALID_RECIPIENT");

        require(_getOwnerOf(id) == address(0), "ALREADY_MINTED");

        // Counter overflow is incredibly unrealistic.
        unchecked {
            _balanceOf[to]++;
        }

        _setOwnerOf(id, to);

        emit Transfer(address(0), to, id);
    }

    function _burn(uint256 id) internal virtual override {
        address owner = _getOwnerOf(id);

        require(owner != address(0), "NOT_MINTED");

        // Ownership check above ensures no underflow.
        unchecked {
            _balanceOf[owner]--;
        }

        _setOwnerOf(id, address(0));

        delete getApproved[id];

        emit Transfer(owner, address(0), id);
    }

    /// NEW FUNCTIONS ///

    /// @dev Would prefer `_ownerOf` but solmate has this as a mapping and
    /// it cannot be override
    function _getOwnerOf(uint256 id) internal view virtual returns (address);

    function _setOwnerOf(uint256 id, address owner) internal virtual;
}
