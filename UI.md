# ExtendableDAO UI

This document details how the User Interface is layed out and how it interacts with the sandbox.

## Sandbox Faucet

A simple page that allows a user to recieve an amount of Algo provided by the user to an address they specify. This Algo is sent from one of the prefunded accounts in the sandbox KMD server. This allows users an easy way to fund their own wallets to use this example.

```
+---------------------+
| Header - Faucet     |
+---------------------+
| [ DAO ]  [ Faucet ] |
+---------------------+
|                     |
|  Addr: ___________  |
|                     |
|  Algo: ____ [ Go ]  |
|                     |
+---------------------+
```

## DAO Deployment

When a user first visits the page and there is no DAO deployed, the option to deploy a new DAO Smart Contract or enter the ApplicationID of an existing DAO should be the only options.

The deployment process is a multistep process, including deploying the smart contract, creating an ASA to be used as the DAO token, and initialising the DAO. After this users may then OptIn to the DAO if they hold the native ASA token.

```
+-------------------------+
| Header - Deploy/Connect |
+-------------------------+
| [ DAO ]  [ Faucet ]     |
+-------------------------+
|                         |
|  ID: ______ [ Go ]      |
|                         |
|       OR                |
|                         |
|  [ Deploy New ]         |
|                         |
+-------------------------+
```

## Interacting with the DAO

Once a DAO exists and a user can begin interacting with it, a user may OptIn to the DAO as long as they hold the native ASA for that DAO.

Additional options of proposing new functionality and voting on proposed functionality should now be available.

Proposed functionality can be found in the DAOs global state, containing votes for/against.
 
 ```
+------------------------------------+
| Header - Proposals                 |
+------------------------------------+
| [ DAO ]  [ Faucet ]                |
+------------------------------------+
|                                    |
|  Proposals:                        |
|    * 003 - 89% Approval - Details  |
|    * 053 - 55% Approval - Details  |
|    * 061 - 99% Approval - Details  |
|                                    |
|  [ New Proposal ]                  |
|                                    |
+------------------------------------+
```
```
+------------------------------------+
| Header - Proposal Details / Voting |
+------------------------------------+
| [ DAO ]  [ Faucet ]                |
+------------------------------------+
|                                    |
|  053 Details                       |
|                                    |
|  55% Approve                       |
|  45% Reject                        |
|                                    |
|  Vote: ______ [ For ] [ Against ]  |
|                                    |
+------------------------------------+
```
