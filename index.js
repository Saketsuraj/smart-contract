async function getValue(){
	//import ether
	const ethers = require('ethers');
	//Get abi
	const abi = [
		{
			"anonymous": false,
			"inputs": [
				{
					"indexed": true,
					"internalType": "address",
					"name": "previousOwner",
					"type": "address"
				},
				{
					"indexed": true,
					"internalType": "address",
					"name": "newOwner",
					"type": "address"
				}
			],
			"name": "OwnershipTransferred",
			"type": "event"
		},
		{
			"inputs": [],
			"name": "owner",
			"outputs": [
				{
					"internalType": "address",
					"name": "",
					"type": "address"
				}
			],
			"stateMutability": "view",
			"type": "function"
		},
		{
			"inputs": [],
			"name": "renounceOwnership",
			"outputs": [],
			"stateMutability": "nonpayable",
			"type": "function"
		},
		{
			"inputs": [
				{
					"internalType": "address",
					"name": "newOwner",
					"type": "address"
				}
			],
			"name": "transferOwnership",
			"outputs": [],
			"stateMutability": "nonpayable",
			"type": "function"
		}
	]
	//usdt abi contains all the variables and functions
	const usdtabi = require("./abi.json")
	//Using infura as a provider
	let provider = new ethers.providers.JsonRpcProvider('https://rinkeby.infura.io/v3/94463a4ce80f44389bb2afa4c0b50006');
	  
	var signer;
	provider.listAccounts().then((accounts) => {
		signer = provider.getSigner(accounts[1]);
		// console.log(signer)
	});

	// Address where smart contract is deployed
	const address = "0x7cB127B324A314b01088C5Cc50Ec4651977c77f0";
	//Interacting with contract
	const contract = new ethers.Contract(address, usdtabi, provider);
	//Reading values from contract
	let val = await contract.whitelistUnoCap()
	console.log(val)
}
getValue()
