// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";

contract EIP712Verifier is EIP712 {
    // 定义消息类型哈希
    bytes32 public constant TRANSFER_TYPEHASH = keccak256(
        "Transfer(address from,address to,uint256 value)"
    );

    constructor() EIP712("MyApp", "1.0.0") {}

    // 验证 Transfer 签名的函数
    function verifyTransfer(
        address from,
        address to,
        uint256 value,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external view returns (bool) {
        // 构建消息哈希
        bytes32 structHash = keccak256(
            abi.encode(
                TRANSFER_TYPEHASH,
                from,
                to,
                value
            )
        );

        // 计算签名者的地址
        bytes32 digest = _hashTypedDataV4(structHash);
        address signer = ECDSA.recover(digest, v, r, s);

        // 验证签名者是否为 from 地址
        return signer == from;
    }

    // 替代验证方法，直接使用 bytes 格式的签名
    function verifyTransferWithSignature(
        address from,
        address to,
        uint256 value,
        bytes calldata signature
    ) external view returns (bool) {
        bytes32 structHash = keccak256(
            abi.encode(
                TRANSFER_TYPEHASH,
                from,
                to,
                value
            )
        );

        bytes32 digest = _hashTypedDataV4(structHash);
        return SignatureChecker.isValidSignatureNow(
            from,
            digest,
            signature
        );
    }
}  