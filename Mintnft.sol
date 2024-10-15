pragma solidity ^0.8.25;


contract MetaDogeUnityPass is ERC1155,ERC2981, Ownable {
    constructor(uint96 _royaltyFeesInBips) ERC1155("") Ownable(msg.sender) {
                setRoyaltyInfo(owner(), _royaltyFeesInBips);

        deployer = msg.sender;
    }

    address public deployer;
    uint totalSupply = 50000;
    uint counter = 0;
    string public name = "MetaDogeUnity Pass";
    
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

     function mint(address account, uint256 id, uint256 amount, bytes memory data)
         public
         onlyOwner
     {
         require(counter <= totalSupply);
         _mint(account, id, amount, data);
         counter ++;
     }

     function buyNft() public payable
    {
        require(msg.value >=  1000000000000000 wei,"send ether"); //0.001 ether
        
        require(counter <= totalSupply);
        _mint(msg.sender, 1, 1, "0x");
        counter ++;
        (bool success,)  = owner().call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

   
    function uri(uint256 tokenId) override public pure returns (string memory) {
        return(
        string(abi.encodePacked(
        "https://ipfs.io/ipfs/QmaycYDJZEhmYJNLCVe5UEwrgE9r7Br76R8iNStt3bq5o4/",
        Strings.toString(tokenId),
        ".json"
            )));
    }

  

     function transfer(address to) public {
         if(balanceOf(msg.sender, 1)>=1){
             safeTransferFrom(msg.sender, to, 1, 1, "0x");
         }
     }


        function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


     function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
        _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
    }

    
    

