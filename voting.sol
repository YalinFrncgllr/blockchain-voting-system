// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    address public owner;
    
    mapping(bytes32 => bool) public hasVoted; // TC kimlik numarası hashlenmiş olarak kaydediliyor
    mapping(string => uint256) public votes; // Adayların aldığı oylar

    string[] public candidates; // Aday listesi

    constructor(string[] memory _candidates) {
        owner = msg.sender; // Kontratı başlatan kişi "owner" olacak
        candidates = _candidates;
    }

    function vote(string memory candidate, string memory tcNumber) public {
        // TC kimlik numarasını hashleyelim
        bytes32 hashedTc = keccak256(abi.encodePacked(tcNumber));

        require(!hasVoted[hashedTc], "You already used your vote!"); // Aynı TC ile ikinci kez oy verilemez

        // Adayın geçerli olup olmadığını kontrol et
        bool validCandidate = false;
        for (uint i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidate)) == keccak256(abi.encodePacked(candidates[i]))) {
                validCandidate = true;
                break;
            }
        }
        require(validCandidate, "Invalid candidate!");

        // TC kimlik hashini kaydet ve oy ekle
        hasVoted[hashedTc] = true;
        votes[candidate]++;
    }
}
