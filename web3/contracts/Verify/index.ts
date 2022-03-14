import { web3 } from "../..";
import abi from "./abi.json";

const contract = web3 && (
    new web3.eth.Contract(abi as any, "0xA009360CB04647c46a9Ca8Ab6d43301eabEd1344")
)

export { contract };