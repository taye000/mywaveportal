const main = async () => {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal"); //compiles our solidity contract
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  }); //deploys our solidity contract

  await waveContract.deployed();
  console.log("contract deployed to: ", waveContract.address); //logs the address of the deployed contract on the blockchain

  //get contract balance
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "The current balance is: ",
    contractBalance,
    hre.ethers.utils.formatEther(contractBalance)
  );

  //send wave
  let waveTxn1 = await waveContract.wave("A f'n message"); //send a new wave by calling the function
  await waveTxn1.wait(); //wait for the transaction to be mined on the blockchain

  //send another wave
  let waveTxn2 = await waveContract.wave("Another f'n message"); //send a new wave by calling the function
  await waveTxn2.wait(); //wait for the transaction to be mined on the blockchain

  //get contract balance after transaction
  contractBalance = hre.ethers.provider.getBalance(waveContract.address);
  console.log("contract balance", hre.ethers.utils.formatEther(contractBalance));

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0); //exit node without errors
  } catch (error) {
    console.log(error);
    process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
  }
};

runMain();
