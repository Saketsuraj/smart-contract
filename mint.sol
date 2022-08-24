pragma solidity ^0.8.6;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract deployExpNft is Ownable, ERC721Enumerable {

    using Strings for uint;
    string public _tokenBaseURI;

    constructor (string memory nftName, string memory nftSymbol) ERC721(nftName, nftSymbol) {}

    uint public currentIndex;
    uint public maxSupply = 10000;
    uint public whitelistUnoCap = 2000;
    uint public whitelistDosCap = 3000;
    uint public ownerMintReserved = 200;
    uint public individualUnoCap = 2;
    uint public individualDosCap = 2;
    uint public whitelistUnoStartTime = 1661512348;
    uint public whitelistDosStartTime = 1661472748;
    uint public whitelistUnoEndTime = 1661515948;
    uint public whitelistDosEndTime = 1661602348;
    uint public whitelistUnoMintPrice = .1 ether;
    uint public whitelistDosMintPrice = .2 ether;
    uint public publicMintPrice = .3 ether;

    uint public ownerMinted;

    mapping (address => bool) public whitelistUno;
    mapping (address => bool) public whitelistDos;
    mapping (address => uint) public whitelistUnoTotalMinted;
    mapping (address => uint) public whitelistDosTotalMinted;

    modifier unoChecks(uint amount) {
        require (whitelistUno[msg.sender], 'Error: You are not in whitelist uno');
        require (block.timestamp > whitelistUnoStartTime, 'Error: Whitelist uno has not yet started');
        require (whitelistUnoEndTime > block.timestamp, 'Error: Whitelist uno has ended');
        require (msg.value == whitelistUnoMintPrice * amount, 'Error: Transaction Underpriced');
        require (individualUnoCap >= whitelistUnoTotalMinted[msg.sender]+amount, 'Error: Cannot mint more than allocated');
        require (maxSupply >= currentIndex + amount, 'Error: Max Supply Reached');
        _;
    }

    modifier dosChecks(uint amount) {
        require (whitelistDos[msg.sender], 'Error: You are not in whitelist uno');
        require (block.timestamp > whitelistDosStartTime, 'Error: Whitelist uno has not yet started');
        require (whitelistDosEndTime > block.timestamp, 'Error: Whitelist uno has ended');
        require (msg.value == whitelistDosMintPrice * amount, 'Error: Transaction Underpriced');
        require (individualDosCap >= whitelistDosTotalMinted[msg.sender]+amount, 'Error: Cannot mint more than allocated');
        require (maxSupply >= currentIndex + amount, 'Error: Max Supply Reached');
        _;
    }
    
    modifier publicChecks(uint amount) {
        require (whitelistDos[msg.sender], 'Error: You are not in whitelist uno');
        require (block.timestamp > whitelistDosEndTime, 'Error: Public mint has not started');
        require (msg.value == publicMintPrice * amount, 'Error: Transaction Underpriced');
        require (maxSupply >= currentIndex + amount + ownerMintReserved, 'Error: Max Supply Reached');
        _;
    }

    function ownerMint (uint amount) external payable onlyOwner{
        require (maxSupply >= currentIndex + amount, 'Error: Max Supply Reached');
        require (ownerMintReserved >= ownerMinted+ amount, 'Error: Minted All Reserved Tokens');
        for (uint i =0;i<amount;i++) {
            currentIndex++;
            ownerMinted ++;
            _mint(msg.sender, currentIndex);
        }
    }


    function whitelistUnoMint (uint amount) external payable unoChecks(amount) {
        for (uint i =0;i<amount;i++) {
            currentIndex++;
            _mint(msg.sender, currentIndex);
        }
    } 

    function whitelistDosMint (uint amount) external payable dosChecks(amount) {
        for (uint i =0;i<amount;i++) {
            currentIndex++;
            _mint(msg.sender, currentIndex);
        }
    } 

    function publicMint (uint amount) external payable publicChecks (amount) {
        for (uint i =0;i<amount;i++) {
            currentIndex++;
            _mint(msg.sender, currentIndex);
        }    
    }

    function withDrawFunds () external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

     function setBaseURI(string calldata URI) external onlyOwner  {
        _tokenBaseURI = URI;
    }

    function tokenURI(uint tokenId) public view override(ERC721) returns (string memory) {
        require(_exists(tokenId), "Cannot query non-existent token");
        return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
    }

    function changeOwnerMint (uint amount) external onlyOwner {
        ownerMintReserved = amount;
    }

     function addToWhitelistUno (address _to) external onlyOwner {
        whitelistUno[_to] = true;
    }

    function blackListUno(address _to) external onlyOwner {
        whitelistUno[_to] = false;
    }

    function addToWhitelistDos (address _to) external onlyOwner {
        whitelistDos[_to] = true;
    }

    function blackListDos(address _to) external onlyOwner {
        whitelistDos[_to] = false;
    }

    function setWhitelistUnoStartTime (uint _time) external onlyOwner {
        whitelistUnoStartTime = _time;
    }

    function setWhitelistUnoEndTime (uint _time) external onlyOwner {
        whitelistUnoEndTime = _time;
    }

    function setWhitelistDosStartTime (uint _time) external onlyOwner {
        whitelistDosStartTime = _time;
    }

    function setWhitelistDosEndTime (uint _time) external onlyOwner {
        whitelistDosEndTime = _time;
    }

    function setWhiteListUnoCap (uint _cap) external onlyOwner {
        whitelistUnoCap = _cap;
    }

    function setWhiteListDosCap (uint _cap) external onlyOwner {
        whitelistDosCap = _cap;
    }

    function setWhiteListUnoIndividualCap (uint _indiCap) external onlyOwner {
        individualUnoCap = _indiCap;
    }

    function setWhiteListDosIndividualCap (uint _indiCap) external onlyOwner {
        individualDosCap = _indiCap;
    }

    function setWhitelistUnoMintPrice (uint _price) external onlyOwner {
        whitelistUnoMintPrice = _price;
    }

    function setWhitelistDosMintPrice (uint _price) external onlyOwner {
        whitelistDosMintPrice = _price;
    }

    function setPublicMintPrice (uint _price) external onlyOwner {
        publicMintPrice = _price;
    }

}