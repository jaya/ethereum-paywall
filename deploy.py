import solc
from web3 import Web3, HTTPProvider
import json

source_file = './contracts/Coin.sol'
artifacts = solc.compile_files([source_file])

print(artifacts.keys())

coin_artifact = artifacts[source_file + ':' + 'Coin']

json.dump(
    coin_artifact['abi'],
    open('web/public/contract_interface.json', 'w'), indent=2)

web3 = Web3(HTTPProvider('http://localhost:8545'))

print('Owner:', web3.eth.accounts[0])

Coin = web3.eth.contract(abi=coin_artifact['abi'],
                         bytecode=coin_artifact['bin'])

tx_hash = Coin.deploy(transaction={'from': web3.eth.accounts[0] })
tx_receipt = web3.eth.getTransactionReceipt(tx_hash)

print('\nRECEIPT:')
for key, value in tx_receipt.items(): print('\t', key, value)

contract_address = tx_receipt['contractAddress']

json.dump(contract_address, open('web/public/contract_address.json', 'w'))
