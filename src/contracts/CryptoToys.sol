// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.8.0;
pragma abicoder v2;

import "./ERC721.sol";

contract CryptoToys is ERC721 {
    // ======================
    // Structs
    // ======================

    struct CryptoToy {
        uint256 tokenId;
        string tokenName;
        string tokenURI;
        address payable mintedBy;
        address payable currentOwner;
        address payable previousOwner;
        uint256 price;
        uint256 numberOfTransfers;
        bool forSale;
    }

    // ======================
    // Fields
    // ======================

    string public collectionName;
    string public collectionNameSymbol;
    uint256 public cryptoToyCounter;

    mapping(uint256 => CryptoToy) public allCryptoToys;
    mapping(string => bool) public tokenNameUsed;
    mapping(bytes32 => bool) public colorPaletteUsed;
    mapping(string => bool) public tokenURIUsed;

    // ======================
    // Modifiers
    // ======================

    modifier onlyTokenOwner(uint256 _tokenId) {
        require(msg.sender == ownerOf(_tokenId), "Caller not token owner");
        _;
    }

    // ======================
    // Constructor
    // ======================

    constructor() ERC721("Crypto Toys Collection", "CT") {
        collectionName = name();
        collectionNameSymbol = symbol();
    }

    // ======================
    // Getters
    // ======================

    function getTokenOwner(uint256 _tokenId) public view returns (address) {
        return ownerOf(_tokenId);
    }

    function getTokenMetaData(uint _tokenId)
        public
        view
        returns (string memory)
    {
        return tokenURI(_tokenId);
    }

    function getNumberOfTokensMinted() public view returns (uint256) {
        return totalSupply();
    }

    function getNumberOfTokensOwned(address _owner)
        public
        view
        returns (uint256)
    {
        return balanceOf(_owner);
    }

    function getTokenExists(uint256 _tokenId) public view returns (bool) {
        return _exists(_tokenId);
    }

    function isColorPaletteUsed(string[] calldata _colors)
        external
        view
        returns (bool)
    {
        return colorPaletteUsed[_encodeColorPalette(_colors)];
    }

    // ======================
    // Mutators
    // ======================

    function mintCryptoToy(
        string memory _name,
        string memory _tokenURI,
        uint256 _price,
        string[] calldata _colors
    ) external {
        _requireTokenNotExist(cryptoToyCounter + 1);
        _requireUniqueToken(_name, _tokenURI, _colors);
        cryptoToyCounter++;

        // mint the token and set uri
        _mint(msg.sender, cryptoToyCounter);
        _setTokenURI(cryptoToyCounter, _tokenURI);

        // mark token minted
        colorPaletteUsed[_encodeColorPalette(_colors)] = true;
        tokenURIUsed[_tokenURI] = true;
        tokenNameUsed[_name] = true;

        // add crypto toy to mapping
        allCryptoToys[cryptoToyCounter] = CryptoToy(
            cryptoToyCounter,
            _name,
            _tokenURI,
            msg.sender,
            msg.sender,
            address(0),
            _price,
            0,
            true
        );
    }

    // buy a token by passing in the token's id
    function buyToken(uint256 _tokenId) public payable {
        _requireTokenExists(_tokenId);
        _requireEligibleForBuying(_tokenId);

        CryptoToy memory cryptotoy = allCryptoToys[_tokenId];
        require(msg.value >= cryptotoy.price, "Not enough ether sent");

        // transfer the token from owner to the caller of the function (buyer)
        _transfer(ownerOf(_tokenId), msg.sender, _tokenId);

        // change token
        address payable sendTo = cryptotoy.currentOwner;
        sendTo.transfer(msg.value);
        cryptotoy.previousOwner = cryptotoy.currentOwner;
        cryptotoy.currentOwner = msg.sender;
        cryptotoy.numberOfTransfers += 1;

        // save changed token
        allCryptoToys[_tokenId] = cryptotoy;
    }

    function changeTokenPrice(uint256 _tokenId, uint256 _newPrice)
        public
        onlyTokenOwner(_tokenId)
    {
        _requireTokenExists(_tokenId);

        // update token's price with new price
        allCryptoToys[_tokenId].price = _newPrice;
    }

    // switch between set for sale and set not for sale
    function toggleForSale(uint256 _tokenId) public onlyTokenOwner(_tokenId) {
        _requireTokenExists(_tokenId);

        // toggle set for sale
        allCryptoToys[_tokenId].forSale = !allCryptoToys[_tokenId].forSale;
    }

    // ======================
    // Internal
    // ======================

    function _requireTokenExists(uint256 _tokenId) internal view {
        require(
            _exists(_tokenId),
            "Supplied tokenId does not reffer to a token"
        );
    }

    function _requireTokenNotExist(uint256 _tokenId) internal view {
        require(!_exists(_tokenId), "Supplied tokenId does reffer to a token");
    }

    function _encodeColorPalette(string[] memory _colors)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(_colors));
    }

    function _requireUniqueToken(
        string memory _name,
        string memory _tokenURI,
        string[] calldata _colors
    ) internal view {
        require(
            !colorPaletteUsed[_encodeColorPalette(_colors)],
            "Color palette already used"
        );
        require(!tokenURIUsed[_tokenURI], "Token URI already used");
        require(!tokenNameUsed[_name], "Token name already used");
    }

    function _requireEligibleForBuying(uint256 _tokenId) internal view {
        address tokenOwner = ownerOf(_tokenId);
        require(tokenOwner != address(0), "Token owner address zero");
        require(tokenOwner != msg.sender, "Caller is token owner");

        require(allCryptoToys[_tokenId].forSale, "Token not for sale");
    }
}
