import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import Voting from '../contracts/Voting.json'; // ABI dosyasını doğru import ettiğinden emin ol

const VotingComponent = () => {
  const [account, setAccount] = useState('');
  const [contract, setContract] = useState(null);
  const [candidates, setCandidates] = useState([]);
  const [vote, setVote] = useState('');
  const [loading, setLoading] = useState(true); // Yükleniyor durumu

  // MetaMask ile bağlanma ve bilgileri alma
  useEffect(() => {
    const loadBlockchainData = async () => {
      if (window.ethereum) {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const address = await signer.getAddress();
        setAccount(address);

        const network = await provider.getNetwork();
        const contractAddress = "0xYourContractAddressHere"; // Gerçek kontrat adresini buraya ekle
        const votingContract = new ethers.Contract(contractAddress, Voting.abi, signer);
        setContract(votingContract);

        const candidatesList = await votingContract.getCandidates(); // Gerçek kontrat fonksiyonuna göre güncelle
        setCandidates(candidatesList);
        setLoading(false); // Yükleme tamamlandı
      } else {
        alert('Please install MetaMask!');
      }
    };

    loadBlockchainData();
  }, []);

  const handleVote = async () => {
    if (contract && vote) {
      try {
        setLoading(true); // Oy verilirken yükleniyor
        const tx = await contract.vote(vote); // vote işlemini kontrata gönder
        await tx.wait();
        alert('Vote successful!');
        setLoading(false);
      } catch (err) {
        console.error(err);
        alert('Vote failed!');
        setLoading(false);
      }
    } else {
      alert('Please select a candidate');
    }
  };

  return (
    <div>
      <h2>Blockchain Voting System</h2>
      {loading ? (
        <p>Loading...</p> // Yükleme mesajı
      ) : (
        <>
          <h3>Connected Account: {account}</h3>
          <h4>Select a candidate to vote for:</h4>
          <select onChange={(e) => setVote(e.target.value)}>
            <option value="">Select a candidate</option>
            {candidates.map((candidate, index) => (
              <option key={index} value={candidate}>{candidate}</option>
            ))}
          </select>
          <button onClick={handleVote} disabled={loading}>Vote</button>
        </>
      )}
    </div>
  );
};

export default VotingComponent;
