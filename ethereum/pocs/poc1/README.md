# POC1: Escrow
**Overview:**  This complicated payment distribution pipeline will utilize a central contract to deal with everything related to payment. It will hold the user's payment in escrow and it will distribute the payment to subLevelContracts based on the prediction outcome.<br>

## Contracts
1. Distributor
2. ProviderC (SubLevelC)
3. ContributorC (SubLevelC)
4. AppOwnerC (SubLevelC)

## Process
1. *User* sends funds to *DistributorC* with a temporary escrow ID and a task ID. The temporary escrow ID will be generated client side. The task ID will reference an already instantiated task whose ID is able to be looked up. This task ID references a struct within *DistributorC* which references a ProviderC, a ContributorC, a AppOwnerC, and the percentages these entities receive of the user's payment.
2. User requests for a prediction to be run by Doppler and sends Doppler their temporary escrow ID.
3. Doppler (who initialized the *DistributorC*) sends a request to the Distributor with the user's temporary escrow ID and the outcome of the prediction.
4. *DistributorC* distributes funds based on the outcome received. Funds may possibly be sent to:
  * User (in case of refund)
  * Doppler Foundation
  * ProviderC
  * ContributorC
  * AppOwnerC
5. Each contract within the task, which we will label *subLevelContracts*, distribute funds to the registered individual wallets, which will be stored in an array on each contract.
