// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    address public owner;
    
    mapping(address => bool) public hasVoted; // Oy verilip verilmediğini kontrol eder
    mapping(string => uint256) public votes; // Adayların aldığı oyları saklar

    string[] public candidates; // Aday listesi

    // Kontratı başlatırken adayları belirten constructor
    constructor(string[] memory _candidates) {
        owner = msg.sender; // Kontratı başlatan kişi "owner" olacak
        candidates = _candidates;
    }

    // Oy verme fonksiyonu
    function vote(string memory candidate) public {
        require(!hasVoted[msg.sender], "You already used your vote!"); // Daha önce oy kullanıldı mı kontrol et

        // Adayın geçerli olup olmadığını kontrol et
        bool validCandidate = false;
        for (uint i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidate)) == keccak256(abi.encodePacked(candidates[i]))) {
                validCandidate = true;
                break;
            }
        }
        require(validCandidate, "Invalid candidate!");

        // Oy verildiğini kaydet ve adaya oy ekle
        hasVoted[msg.sender] = true;
        votes[candidate]++;
    }
}
