# Ethereum Private Network and Hello World 3.0
![maxresdefault](https://user-images.githubusercontent.com/16689974/33654116-fccddb36-da23-11e7-829e-48f511e9aaec.jpg)

## Setup Node Ubuntu
Install necessary stuff
```
mkdir ~/ethereum
cd ~/ethereum
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum
```
Setup Genesis.json
```
vim Genesis.json  -- or nano if ur a noob
```
Here is the setup I use. Notice the difficulty. Yeah I have no patience and am using questionable hardware so let's use a difficulty of 1.

```
{
  "config": {
    "chainId": 15,
    "homesteadBlock": 0,
    "eip155Block": 0,
    "eip158Block": 0
  },
  "nonce": "0x0000000000000042",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "difficulty": "0x001",
  "alloc": {

  },
  "coinbase": "0x0000000000000000000000000000000000000000",
  "timestamp": "0x00",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "gasLimit": "0xffffffff"
}
```

Start up it up!

```
geth init Genesis.json
```

Launch Geth, the interactive console for Ethereum (Geth = Go + Etherem)
```
geth --nodiscover console 2>> eth.log
```

Open up a NEW terminal to display a log (useful for debugging and fun to watch)
```
tail -F eth.log
```

Back in terminal 1, setup a new account and check the balance (hint: it should be 0)
```
personal.newAccount()
eth.getBalance(eth.accounts[0])
```

## Setup Node Mac
Exactly the same as above except run the following to install all the stuff:

Prerequisites:
a) [brew](https://brew.sh/)

#### Install brew
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

#### Install Ethereum
```
brew tap ethereum/ethereum
brew install ethereum
```

## Connect two nodes
Get Node 1's address
```
admin
```
Look under node info, find enode, and copy
<img width="1283" alt="screen shot 2017-12-06 at 1 34 48 am" src="https://user-images.githubusercontent.com/16689974/33654693-bdb31b8a-da25-11e7-9e12-96913fa6b06d.png">

#### Connect to Node 1 from Node 2
Paste the enode, filling in the IP Address of the node at <ADDRESS_OF_NODE_1> (port 30303 is default).
```
admin.addPeer('enode://cf2bd74b1b0ddc3240037213f8a074554c75ccde432a0eb1ec0a9a87cbe15c44a8b585626575c2141c06f32d7d86c8c91b240ae1f9dff4debff75e5ced474d0e@<ADDRESS_OF_NODE_1>:30303?discport=0')
```

Verify the connection is made on both Nodes
```
admin.peers
```

## Mine some blocks
So I realized after an hour of waiting that my $5 DigitalOcean droplets weren't going to mine a block anytime soon... even with the low difficulty. Thus, I ended up using my macbook as the miner whenever I wanted something mined.

Here is how you get started mining (I am using the account I created above):
```
miner.setEtherbase(eth.accounts[0])
miner.start()
```

In case it isn't obvious, you stop the miner with:
```
miner.stop()
```

Mining is necessary whenever you need:
1. to fund an account
2. to send a transaction
3. to execute a smart contract
~~4. to heat up your computer~~

## Hello World Contract
Here is a nice contract to get started with:
```
contract mortal {
    /* Define variable owner of the type address */
    address owner;

    /* This function is executed at initialization and sets the owner of the contract */
    function mortal() {
      owner = msg.sender;
    }

    /* Function to recover the funds on the contract */
    function kill() {
      if (msg.sender == owner) selfdestruct(owner);
    }
}

contract greeter is mortal {
    /* Define variable greeting of the type string */
    string greeting;

    /* This runs when the contract is executed */
    function greeter(string _greeting) public {
        greeting = _greeting;
    }

    /* Main function */
    function greet() constant returns (string) {
        return greeting;
    }
}
```
Basically, this does two things:
1. greet: returns whatever string the contract was initiated with
2. kill: destroys the contract

To deploy this, follow these six steps:

1. Copy and paste this code into the compiler at [Remix](remix.ethereum.org):
<img width="1430" alt="screen shot 2017-12-06 at 1 39 48 am" src="https://user-images.githubusercontent.com/16689974/33654890-5fd5473a-da26-11e7-8bae-70809a2cf3bf.png">

**Side Note:** This is the last time we will be using Remix. Remix sort of sucks, and while it is an IDE, it is not a great one.

2. On the right click details and grab the code under "WEB3DEPLOY" which should look similar to this (I copied a slightly different version here):
```
var _greeting = /* var of type string here */ ;
var browser_greeter_sol_greeterContract = web3.eth.contract([{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"greet","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]);
var browser_greeter_sol_greeter = browser_greeter_sol_greeterContract.new(
   _greeting,
   {
     from: web3.eth.accounts[0],
     data: '0x6060604052341561000f57600080fd5b60405161034438038061034483398101604052808051820191905050336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508060019080519060200190610081929190610088565b505061012d565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106100c957805160ff19168380011785556100f7565b828001600101855582156100f7579182015b828111156100f65782518255916020019190600101906100db565b5b5090506101049190610108565b5090565b61012a91905b8082111561012657600081600090555060010161010e565b5090565b90565b6102088061013c6000396000f30060606040526004361061004c576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806341c0e1b514610051578063cfae321714610066575b600080fd5b341561005c57600080fd5b6100646100f4565b005b341561007157600080fd5b610079610185565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156100b957808201518184015260208101905061009e565b50505050905090810190601f1680156100e65780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161415610183576000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b565b61018d6101c8565b6040805190810160405280600f81526020017f48656c6c6f20576f726c6420332e300000000000000000000000000000000000815250905090565b6020604051908101604052806000815250905600a165627a7a723058204f03783520c6602ca4c5436e8cbb4dcf0b880ef3f6385f0a4579a9a2f1bad6a80029',
     gas: '4700000'
   }, function (e, contract){
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {
         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
 })
```

3. Paste this code into the geth console
4. Mine some blocks. When the contract has been mined, you'll see a message:
<img width="1440" alt="screen shot 2017-12-06 at 1 41 56 am" src="https://user-images.githubusercontent.com/16689974/33654995-b5d1c0aa-da26-11e7-990c-b57a122e4f20.png">
5. Run the contract:
```
browser_greeter_sol_greeter.greet()
```
Here was my output:
<img width="127" alt="screen shot 2017-12-06 at 1 42 53 am" src="https://user-images.githubusercontent.com/16689974/33655027-cd48a1d6-da26-11e7-98fa-72419ee0bd8a.png">
6. Pop a bottle, cheers you're now a on your way to becoming a Dapp developer!

<center><img src="https://media1.giphy.com/media/bKBM7H63PIykM/giphy.gif" ></center>

SOURCE for most of this: https://blockgeeks.com/two-node-setup-of-a-private-ethereum/
SOURCE for Mac: https://medium.com/@niceoneallround/creating-a-private-ethereum-network-on-a-mac-c417ab971055
Remix: https://remix.ethereum.org
SOURCE for smart contract: https://github.com/ethereum/go-ethereum/wiki/Contract-Tutorial


## Importing a contract with Web3 in Geth Console

Provide default Eth account for Web3
```
web3.eth.defaultAccount = web3.eth.accounts[0];
```

Find ABI. We will again use Remix for this.
<img width="1429" alt="screen shot 2017-12-06 at 11 17 48 am" src="https://user-images.githubusercontent.com/16689974/33680650-296822a2-da77-11e7-926a-83f584c45dc5.png">


Import the [ABI](https://solidity.readthedocs.io/en/develop/abi-spec.html)
```
var contractInstance = web3.eth.contract(<INSERT_ABI_HERE>);
```

Connect to Address
```
var contract = contractInstance.at(<CONTRACT_ADDRESS>);
```

Check to make sure it worked
```
console.log(contract) --> [object Object]
```

Now you can run functions on the contract (don't forget that you need gas for this)
```
contract.function()
```

SOURCE: https://coursetro.com/posts/code/99/Interacting-with-a-Smart-Contract-through-Web3.js-(Tutorial)
