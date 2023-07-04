An ERC721 implementation, built on Solmate, which allows for packing other info in the `ownerOf` slot. There are two new abstract, internal functions: `_getOwnerOf` and `_setOwnerOf`. All fetching and setting of owner pass through these functions, and it allows for putting the `owner` address in a user-defined struct, which can be packed with other values. 

For example, from `test/mocks/MockERC7210.sol`.

```solidity
    struct info {
        address owner;
        uint96 otherThing;
    }

    mapping (uint256 => info) internal _info;

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
```

The first time I saw this was in the [Art Gobblers](https://github.com/artgobblers/art-gobblers/blob/master/src/utils/token/GobblersERC721.sol#L34-L41) repo, but I am sure it has been done in many places. 