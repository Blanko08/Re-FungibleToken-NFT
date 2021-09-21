// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

// Imports
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract RFT is ERC20 {
    // Variables
    uint public icoSharePrice;
    uint public icoShareSupply;
    uint public icoEnd;

    uint public nftId;
    IERC721 public nft;
    IERC20 public dai;

    address public admin;

    // Constructor
    constructor(
        string memory _name,
        string memory _symbol,
        address _nftAddress,
        uint _nftId,
        uint _icoSharePrice,
        uint _icoShareSupply,
        address _daiAddress) ERC20(_name, _symbol) 
    {
        nftId = _nftId;
        nft = IERC721(_nftAddress);
        icoSharePrice = _icoSharePrice;
        icoShareSupply = _icoShareSupply;
        dai = IERC20(_daiAddress);
        admin = msg.sender;
    }

    // Funciones
    /**
     * @notice Función que comienza la ICO.
     */
    function startIco() external {
        require(msg.sender == admin, 'No eres el duenho.');
        nft.transferFrom(msg.sender, address(this), nftId);
        icoEnd = block.timestamp + 7 * 86400;
    }

    /**
     * @notice Función que permite comprar una parte del NFT.
     * @param _shareAmount Cantidad de partes que va a comprar.
     */
    function buyShare(uint _shareAmount) external {
        require(icoEnd > 0, 'La ICO no ha comenzado todavia.');
        require(block.timestamp <= icoEnd, 'La ICO ha terminado.');
        require(totalSupply() + _shareAmount <= icoShareSupply, 'No hay suficientes partes disponibles.');

        uint daiAmount = _shareAmount * icoSharePrice;
        dai.transferFrom(msg.sender, address(this), daiAmount);
        _mint(msg.sender, _shareAmount);
    }


    /**
     * @notice Función que permite al dueño retirar el balance del contrato y las partes del NFT que no han sido vendidas.
     */
    function withdrawProfits() external {
        require(msg.sender == admin, 'No eres el duenho.');
        require(block.timestamp > icoEnd, 'La ICO no ha finalizado.');
        uint daiBalance = dai.balanceOf(address(this));
        if(daiBalance > 0) {
            dai.transfer(admin, daiBalance);
        }

        uint unsoldShareBalance = icoShareSupply - totalSupply();
        if(unsoldShareBalance > 0) {
            _mint(admin, unsoldShareBalance);
        }
    }
}