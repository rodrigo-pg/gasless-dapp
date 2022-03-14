import Web3 from "web3";

declare global {
    interface Window { web3: Web3; }
}

let web3:Web3;

(async () => {
    if(typeof window !== "undefined"){
        if(window.ethereum){
            web3 = web3 = new Web3(window?.ethereum);
            await web3?.eth?.requestAccounts();
        }
        if(window.web3){
            web3 = new Web3(window.web3.currentProvider);
        }
    } else {
        const provider = new Web3.providers.HttpProvider("https://rinkeby.infura.io/v3/c71e576d70ed4ac089c7739346a53849");
        web3 = new Web3(provider);
    }
})();

export { web3 };