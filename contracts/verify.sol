contract Verify {

    event CouponClaimed (bytes32 hashedMessage, address claimant, uint timestamp);

    mapping(bytes32 => bool) couponsClaimed;
    address constant admin = 0xc5954103D5bd3Da47C3118C41cF6d8B03D498e4D;

    function claimCoupon(bytes32 _hashedMessage, uint8 _v, bytes32 _r, bytes32 _s) external {
        require(!couponsClaimed[_hashedMessage], "coupon already claimed");
        require(verifyMessage(_hashedMessage, _v, _r, _s), "invalid signature or hash");
        couponsClaimed[_hashedMessage] = true;
        emit CouponClaimed(_hashedMessage, msg.sender, block.timestamp);
    }   

    function verifyMessage(bytes32 _hashedMessage, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns (bool) {
        // Esse prefixo deve-se ao fato de que estamos assinando uma mensagem e não uma transação. Desse modo, sem o 
        // prefixo, alguém poderia pegar a assinatura e forjar uma transação, mas, com o prefixo, a transação tornaria-se
        // inválida.
        // Esse é um dos modos de assinar transações através do método personal_sign, pois esse método irá adicionar a qualquer
        // mensagem assinada o prefixo "\x19Ethereum Signed Message:\n32".
        // Esse padrão de assinatura prefixada com o dado acima é conhecida como EIP-191.
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix, _hashedMessage));
        address signer = ecrecover(prefixedHashMessage, _v, _r, _s);
        return signer == admin;
    }

}