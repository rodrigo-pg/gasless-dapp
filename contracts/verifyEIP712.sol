contract VerifyEIP712 {

    event CouponClaimed (bytes32 hashedMessage, address claimant, uint timestamp);

    struct Object {
        string objectType;
        string damagePoints;
        bytes signature;
    }

    mapping(bytes32 => bool) couponsClaimed;
    address constant admin = 0xc5954103D5bd3Da47C3118C41cF6d8B03D498e4D;

    function claimCoupon(Object calldata coupon, uint8 _v, bytes32 _r, bytes32 _s) external {
        //require(!couponsClaimed[_hashedMessage], "coupon already claimed");
        // require(verifyMessage(_hashedMessage, _v, _r, _s), "invalid signature or hash");
        // couponsClaimed[_hashedMessage] = true;
        // emit CouponClaimed(_hashedMessage, msg.sender, block.timestamp);
        bool isSigner = verifyMessage(coupon, _v, _r, _s);
    }   

    function verifyMessage(Object calldata coupon, uint8 _v, bytes32 _r, bytes32 _s) internal view returns (bool) {
        bytes32 hashDomain = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes("OpenSea")),
                keccak256(bytes("1")),
                block.chainid,
                address(this)
            )
        );
        bytes32 hashCoupon = keccak256(
            abi.encode(
                keccak256("Object(string objectType,string damagePoints)"),
                keccak256(bytes(coupon.objectType)),
                keccak256(bytes(coupon.damagePoints))
            )
        );
        bytes32 hashedData = keccak256(abi.encodePacked("\x19\x01", hashDomain, hashCoupon));
        // Poderia utilizar ECDSA.recover aqui, um contrato do openZeppelin, assim, poderíamos 
        // utilizar como parâmetros toda a assinatura ao invés de suas partes e evitar problemas
        // que são existentes na função ecrecover.
        address signer = ecrecover(hashedData, _v, _r, _s);
        return signer == admin;
    }

}