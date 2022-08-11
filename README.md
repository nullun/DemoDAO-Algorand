# DemoDAO

This repository contains an example DAO implementation for the Algorand blockchain. An interesting feature of this implementation is that it allows for extending the functionality of the DAO by means of proposals.

## The Basics

At its core, the smart contract is deployed by whoever wants to create a DAO. This can be an individual or a multisig, however this is just for the setup. Eventually any permissions the creator had are relinquished and given to the members of the DAO.

Once deployed, the initialisation process is triggered by specifying an existing ASA to be used as the native token of the DAO, along with some parameters such as the voting threshold.

The DAO is now live. Meaning anyone who holds a non-zero amount of the native token for the DAO can interact with it. This includes proposing new functionality, voting on existing proposals, or invoking the functionality of the DAO.

# Proposing

One of the most interesting aspects of this DAO design is the ability to extend the functionality of the DAO. This requires smart contract developers to implement what they want the DAO to do in a new smart contract that contains certain methods. Examples of functionality include; opting into or sending assets, calling other applications, and even creating groups of transactions that trade or buy NFTs on existing market places. The author would then deploy a copy of the smart contract along with calling the "proposal" method of the DAO and a vote will begin on whether or not the members of the DAO want it.

# Voting

The voting mechanism can and should be updated for real use, however during development I have been using a threshold which must be reached in order for the vote to pass. Voting is simply token holders stating an amount of their held assets for or against the proposal. Failing to reach this threshold allows for the DAO to reject the proposal. But should the vote pass the threshold, the DAO can now "activate" it, buy deploying its own instance of the functionality smart contract, and allowing the original author to destroy theirs. This makes the DAO the creator of the functionality app, with zero reliance on the original author.

# Invoking

Now depending on how the functionality app was designed, the functionality can be called by calling an "invoke" method via the DAO. An important piece to note is that the DAO will rekey itself to the functionality app upon invocation. However concluding the inner transaction to the functionality app, the DAO will check to make sure the authoritative address has been passed back to itself, disallowing a functionality app to mistakenly or maliciously rekey itself to another address (although the risk of giving the full account to a functionality app still exists without limitations).

