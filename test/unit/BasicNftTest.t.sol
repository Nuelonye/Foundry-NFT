// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "src/BasicNft.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    BasicNft basicNft;

    address USER = makeAddr("user");
    string constant PUGURI = "ipfs://QmdUM2PU2zETKr3jC893NZK6cLc6w7M1zyqF6zBuEqVenV";

    function setUp() public {
        DeployBasicNft deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNftNameIsCorrect() public view {
        // Arrange
        string memory expectedName = "Doggie";

        // Act
        string memory actualName = basicNft.name();

        // Assert
        assertEq(expectedName, actualName);
    }

    function testCanMintAndHaveBalance() public {
        // Arrange
        vm.prank(USER);

        // Act
        basicNft.mintNft(PUGURI);

        // Assert
        assertEq(basicNft.balanceOf(USER), 1);
        assert(keccak256(abi.encodePacked(PUGURI)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}
