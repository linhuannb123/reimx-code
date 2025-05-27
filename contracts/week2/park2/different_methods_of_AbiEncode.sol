// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// 导入 Hardhat 控制台日志库，仅用于开发和测试环境
import "https://github.com/NomicFoundation/hardhat/blob/main/packages/hardhat-core/console.sol";


contract TestAbiEncode {
     
     /**
     * @dev abi.encodePacked方法，只能对基本类型进行编码
     * 展示不同类型使用abi.encodePacked的编码结果 
     */
    // 0x11d7
    // 0x4567
    // 0x34353637
    function testAbiEncodePacked() pure external {
        // 编码uint16类型，转为16进制表示为0x11d7
        console.logBytes(abi.encodePacked(uint16(4567))); 
        // 直接编码bytes2类型值0x4567
        console.logBytes(abi.encodePacked(bytes2(0x4567)));
        // 编码字符串“4567”的uncode编码表示 0x34353637
        console.logBytes(abi.encodePacked("4567"));
    }
    
    /**
    * @dev abi.encode方法，可以对所有类型进行编码
    * 展示不同类型使用abi.encode的编码结果
    */
    // 0x00000000000000000000000000000000000000000000000000000000000011d7 64位(32字节)
    // 0x0000000000000000000000000000000000000000000000000000000000004567 64位(32字节)

    // 0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000043435363700000000000000000000000000000000000000000000000000000000
    // 0000000000000000000000000000000000000000000000000000000000000020 32 表示 bytes32
    // 0000000000000000000000000000000000000000000000000000000000000004 4  表示 4个字节
    // 3435363700000000000000000000000000000000000000000000000000000000 34353637 表示 “4567”

    function testAbiEncode() pure external {

        // 编码uint16类型值4567，自动填充为32字节
        console.logBytes(abi.encode(uint16(4567)));
        // 编码bytes2类型值0x4567,自动填充为32字节
        console.logBytes(abi.encode(0x4567));
        // 编码动态长度的字符串“4567” 32*3 = 96bytes 96*2 = 192个字符  192*4 = 768bit 
        console.logBytes(abi.encode("4567"));
    }

   /**
   * @dev 测试组合编码
   * 展示如何从编码数据中提取原始值
   */
     //      4 * 64 = 256位
     //     4567 => 11d7     "4567" => 0x34353637
     //     11d7   40 => 64 4 => 4 34353637 => "4567"
    // 0x00000000000000000000000000000000000000000000000000000000000011d7000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000043435363700000000000000000000000000000000000000000000000000000000
    // 00000000000000000000000000000000000000000000000000000000000011d7  11d7 => 十进制的4567 
    // 0000000000000000000000000000000000000000000000000000000000000040  64 => bytes64
    // 0000000000000000000000000000000000000000000000000000000000000004  4 => 4个字节
    // 3435363700000000000000000000000000000000000000000000000000000000  34353637 => "4567"的unicode编码
    

    //    0x11d734353637 12位
    // 0x11d7  -> 4567
    // 34353637 -> "4567"

    function TestAbiEncodeCombined() pure external {
        // 编码uint256和string的组合，每个参数占32字节
        console.logBytes(abi.encode(4567,"4567"));
        // 紧密打包编码，不填充，可以导致数据碰撞
        console.logBytes(abi.encodePacked(uint16(4567),"4567"));
    }
    

    /**
    * @dev 测试ABI的解码
    * 展示如何从编码数据中提取原始值
    */

    function testAbiDecode() pure external {
        // 编码uint256和string的组合
        bytes memory _encode=abi.encode(4567,"4567");
        // 解码数据
        (uint256 u,string memory s) = abi.decode(_encode,(uint256,string));
        console.logUint(u);
        console.logString(s);
        
        // abi.encodePacked：它的编码没有办法去解码，因为它不知道怎么去拆分 ,主要应用简单的数据类型的编码
        // abi.encode: 它的编码是可以解码的

        // _encode = abi.encodePacked(uint16("4567"),"4567");
        // (uint256 u2,string memory s2) = abi.decode(_encode,(uint256,string));
        // console.logUint(u2);
        // console.logString(s2);
        
    } 
    
    /**
    * @dev 示例方法，用于测试函数选择器和参数编码
    * @param a 一个uint256类型的数值参数
    * @param b 一个bytes2类型的数值参数
    */
    function testAbiMethod(uint a,bytes2 b) external {
        // 函数体为空，仅用于演示
    }

    // 函数签名 = 函数名+完整的参数定义
    /**
    * @dev 测试abi.encodeWithSignature
    * 展示如何使用 函数签名进行编码
    */
    // 10 + 64 +64...  8+64*2 = 136位
    // 0x04d0f4e9  +  1 +  4567
    // 解码：testAbiMethod(uint256,bytes2) 1 bytes2(0x4567)

    // 0x04d0f4e900000000000000000000000000000000000000000000000000000000000000014567000000000000000000000000000000000000000000000000000000000000
    function testAbiSignature() pure external {
        // 使用函数签名和参数值进行编码
        console.logBytes(abi.encodeWithSignature("testAbiMethod(uint256,bytes2)",1,bytes2(0x4567)));
    }
    
    // selector = bytes4(kaccake256(函数签名))
    /**
    * @dev 测试函数选择器和参数编码
    * 展示如何手动计算选择器并编码函数调用
    */

    // 0x04d0f4e900000000000000000000000000000000000000000000000000000000000000014567000000000000000000000000000000000000000000000000000000000000
    // 0x04d0f4e900000000000000000000000000000000000000000000000000000000000000014567000000000000000000000000000000000000000000000000000000000000
    function testABiSeletor() pure external {
        // 使用合约实例获取函数选择器
        console.logBytes(abi.encodeWithSelector(TestAbiEncode.testAbiMethod.selector,1,bytes2(0x4567)));
        
        // 手动计算函数选择器selector
        bytes4 _selector = bytes4(keccak256("testAbiMethod(uint256,bytes2)"));
        // argument
        console.logBytes(abi.encodePacked(_selector,abi.encode(1,bytes2(0x4567))));
        
    }
    // 根据调用进行编码
    /**
    * @dev 测试abi.encodeCall
    * 展示如何使用abi.encodeCall构建函数调用数据
    */
    // 10 + 64 + 64     136位
    // 0x04d0f4e9 +1 + 4567 
    // 解码：testAbiMethod、1、0x4567
    // 0x04d0f4e900000000000000000000000000000000000000000000000000000000000000014567000000000000000000000000000000000000000000000000000000000000
    function testAbiCall() pure external {
        // 使用abi.encodeCall构建完整的函数调用数据
        console.logBytes(abi.encodeCall(TestAbiEncode.testAbiMethod,(1,0x4567)));
    }
}