// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {BasicNft} from "src/BasicNft.sol";
import {MoodNft} from "src/MoodNft.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";
import {MintBasicNft, MintMoodNft} from "script/Interactions.s.sol";

contract InteractionsTest is Test {
    BasicNft basicNft;
    MoodNft moodNft;
    DeployMoodNft deployer;

    string constant PUGURI = "ipfs://QmdUM2PU2zETKr3jC893NZK6cLc6w7M1zyqF6zBuEqVenV";

    function setUp() public {
        basicNft = new BasicNft();
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testMintBasicNftIntegration() public {
        // Arrange
        MintBasicNft minter = new MintBasicNft();

        // Act
        minter.mintNftOnContract(address(basicNft));
        string memory tokenUri = basicNft.tokenURI(0);

        // Assert
        assertEq(basicNft.balanceOf(msg.sender), 1);
        assertEq(keccak256(abi.encodePacked(tokenUri)), keccak256(abi.encodePacked(PUGURI)));
    }

    function testMintMoodNftIntegration() public {
        // Arrange
        MintMoodNft minter = new MintMoodNft();

        // Act
        minter.mintMoodNftOnMoodNftContract(address(moodNft));
        string memory tokenUri = basicNft.tokenURI(0);

        // Assert
        console.log(tokenUri);
        assertEq(moodNft.balanceOf(msg.sender), 1);
    }

    function testConvertSvgToImageUri() public view {
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happySvg = vm.readFile("./img/happy.svg");

        console.log(deployer.svgToImageURI(sadSvg));
        console.log(deployer.svgToImageURI(happySvg));
    }
}
