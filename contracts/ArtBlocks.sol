// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/utils/Address.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

contract ArtBlocks is ERC1155, Ownable, ReentrancyGuard {
    using Strings for uint256;
    using Address for address;
    using Counters for Counters.Counter;

    event BlockMinted(
        address indexed _artBlockOwner,
        uint256 indexed _blockID,
        string _paintingID,
        string _blockName
    );

    Counters.Counter private _blockIDs;
    string internal _metadataBaseURI;

    //WIP: can be used by dapp to show owner of the token or block. Can be replaced to use directly by backend
    mapping(uint256 => address) private _owners;

    //WIP: Add owner of painting, any other details if required as well
    struct Painting {
        uint256 totalBlocks;
        uint256[] blockIDs;
        mapping(string => uint256) blockNames;
    }

    struct PaintingData {
        uint256 totalBlocks;
        uint256[] blockIDs;
    }

    // paintingID => Painting Details
    mapping(string => Painting) private _paintings;

    //lets find other ways to do this something like registry etc.
    //if limits go above uint256 deploy another erc1155. (Confirm)
    constructor(string memory metadataBaseURI) ERC1155(metadataBaseURI) {
        _setMetadataBaseURI(metadataBaseURI);
    }

    function _setMetadataBaseURI(string memory _newMetadataBaseURI)
        internal
        onlyOwner
    {
        _metadataBaseURI = _newMetadataBaseURI;
    }

    function uri(uint256 _blockID)
        public
        view
        override
        returns (string memory)
    {
        //add any check if required
        return
            string(abi.encodePacked(_metadataBaseURI, (_blockID.toString())));
    }

    function mintBlock(
        address _artBlockOwner,
        string memory _paintingID,
        uint256 _totalBlocks,
        string memory _blockName
    ) public nonReentrant() returns (uint256 _blockID) {
        //add checks and maintain array of ids so that we don't mint again. Done (handled with counter)
        // how can I determine who calls this method i.e who can mint. Add relevant checks here. - TO-DO: Devanshu Sir.
        //add handling so that we don't mint past the limit (maybe frontend can handle it as well) - Done
        //add handling so that we dont mint two of any tokenID (maybe counter should handle it) - Done

        Painting storage painting = _paintings[_paintingID];
        if (painting.blockIDs.length > 0) {
            //painting exists in blockchain
            
            require(painting.totalBlocks == _totalBlocks,
                'INVALID_ACTION: Total blocks of painting not matched with given total blocks'
            );
            require(
                painting.blockNames[_blockName] == 0,
                'INVALID_ACTION: This block name is already exists'
            );
            require(
                painting.blockIDs.length < _totalBlocks,
                'INVALID_ACTION: All blocks for this painting have been minted'
            );
        } else {
            //painting does not exists in blockchain
            _paintings[_paintingID].totalBlocks = _totalBlocks;
        }
        _blockIDs.increment();
        uint256 newBlockID = _blockIDs.current();
        _mint(_artBlockOwner, newBlockID, 1, '');
        _paintings[_paintingID].blockIDs.push(newBlockID);
        _paintings[_paintingID].blockNames[_blockName] = newBlockID;
        _owners[newBlockID] = _artBlockOwner;
        // emit event for newly minted block (NFT) for backend
        emit BlockMinted(_artBlockOwner, newBlockID, _paintingID, _blockName);
        return newBlockID;
    }

    function getPaintingData(string memory __paintingID)
        public
        view
        returns (PaintingData memory painting)
    {
        painting.totalBlocks = _paintings[__paintingID].totalBlocks;
        painting.blockIDs = _paintings[__paintingID].blockIDs;
    }

    function getBlockID(string memory _paintingID, string memory _blockName)
        public
        view
        returns (uint256 _blockID)
    {
        Painting storage painting = _paintings[_paintingID];
        require(
            painting.blockIDs.length > 0,
            'INVALID_ACTION: No Blocks minted for this painting'
        );
        require(
            painting.blockNames[_blockName] != 0,
            'INVALID_ACTION: No block minted for this block name'
        );
        return painting.blockNames[_blockName];
    }

    function ownerOf(uint256 _id) external view returns (address _owner) {
        _owner = _owners[_id];
        require(
            _owner != address(0),
            'INVALID_ACTION: This token is not owned by any address'
        );
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        //check if we need to override this in some way or the other to specify quantity directly as 1.
        ERC1155.safeTransferFrom(from, to, id, amount, data);
        _owners[id] = to;
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        ERC1155.safeBatchTransferFrom(from, to, ids, amounts, data);
        for (uint256 i = 0; i < ids.length; ++i) {
            _owners[ids[i]] = to;
        }
    }

    function _burn(
        address account,
        uint256 id,
        uint256 amount
    ) internal virtual override {
        ERC1155._burn(account, id, amount);
        _owners[id] = address(0);
    }

    //can be used by the dapp directly to show on UI how many blocks are minted for this painting
    function getTotalMintedBlocks(string memory _paintingID)
        public
        view
        returns (uint256 _totalMintedBlocks, uint256 _totalBlocks)
    {
        Painting storage painting = _paintings[_paintingID];
        require(
            painting.blockIDs.length > 0,
            'INVALID_ACTION: No Blocks minted for this painting'
        );
        return (painting.blockIDs.length, painting.totalBlocks);
    }

    //add batchMint and batchBurn if required based on requirment.
}
