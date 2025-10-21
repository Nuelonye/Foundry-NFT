// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "src/MoodNft.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";

contract MoodNftTest is Test {
    MoodNft moodNft;

    address OWNER = makeAddr("owner");

    function setUp() public {
        DeployMoodNft deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testMintMoodNft() public {
        vm.prank(OWNER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));

        assertEq(moodNft.balanceOf(OWNER), 1);
        assertEq((moodNft.getTokenCounter() - 1), 0);
    }

    function testFlipMoodNft() public {
        // Arrange
        vm.prank(OWNER);
        moodNft.mintNft();
        string memory tokenUriBeforeFlip = moodNft.tokenURI(0);
        uint256 moodBeforeFlip = uint256(moodNft.getMood(0));

        // Act
        vm.prank(OWNER);
        moodNft.flipMood(0);
        string memory tokenUriAfterFlip = moodNft.tokenURI(0);
        uint256 moodAfterFlip = uint256(moodNft.getMood(0));

        // Assert
        assert(moodBeforeFlip != moodAfterFlip);
        assert(keccak256(abi.encodePacked(tokenUriBeforeFlip)) != keccak256(abi.encodePacked(tokenUriAfterFlip)));
    }
}
