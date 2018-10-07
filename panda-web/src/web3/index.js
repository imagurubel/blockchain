import Web3 from 'web3';
import abi from './abi';
const web3 = new Web3(Web3.currentProvider || new Web3.providers.HttpProvider('http://127.0.0.1:9545/'));
window.web3 = web3;
const contract = new web3.eth.Contract(abi);
export { contract };
export default web3;