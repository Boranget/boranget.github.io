---
title: encrypt
date: 2023-08-16 17:15:30
updated: 2023-08-17 10:35:19
tags:
  - 加密算法
categories:
  - 笔记
---

# AES加密

AES支持三种长度的密钥：128位、192位、256位，分别称之为AES128、AES192和AES256。

AES加密会把明文拆成一个一个的明文块，每个明文块128bit，如果最后一块长度不足128位，则默认使用缺失的字节数填充。接着对这些明文块分别加密，将加密结果拼接形成最终加密结果。

在加解密过程，每个明文块会作为4*4字节的矩阵进行处理

加密过程包括如下四步

- AddRoundKey（轮密钥加）

  矩阵中的每个字节都与该次轮密钥（round key）做异或运算

- SubBytes（字节替代）

  通过非线性的替换函数，用查找表的方式把每个字节替换成对应的字节

- ShiftRows（行移位）

  将矩阵中的每个横列进行循环式移位

- MixColumns（列混淆）

  为了充分混合矩阵中各个直行的操作，使用线性转换来混合每列的四个字节。

## 填充方式

- 不填充 NoPadding

  不进行填充，要求明文必须位16个字节的整数倍。

- 长度填充 PKCS5Padding（默认）

  填充的数据为16-最后一块字节数：相差长度

  若明文为16个字节的整数倍，则填充16个字节的数据，其值都为16（16-0）

  若明文非16字节整数倍，则最后一块肯定不足16个字节，此时将最后一块补齐为16字节，每个字节的值为相差长度

- 随机长度填充 ISO10126Padding

  与长度填充类似，不同之处在于相差长度只保存在最后一字节，其余字节使用随机数填充。

## 加密模式

- ECB（默认）

  电码本模式 Electronic Codebook Book

  根据密钥的位数，将明文分为不同块加密，加密结果拼接，缺点是如果明文块相同，那么密文块也相同。

- CBC

  密码分组链接模式 Cipher Block Chaining

  引入一个初始向量，使用该向量与第一块数据异或，接着加密作为第一块的加密结果；第二块数据使用第一块的加密结果进行异或，接着加密，以此类推。就算明文块相同，密文块也不会相同。缺点是加密无法并行。

- CFB

  密码反馈模式 Cipher FeedBack

- OFB

  输出反馈模式 Output FeedBack

# Base64

## base64URL安全编码

[URL安全的Base64编码 - 张善友 - 博客园 (cnblogs.com)](https://www.cnblogs.com/shanyou/p/5474647.html#:~:text=URL安全的Base64编码适用于以URL方式传递Base64编码结果的场景。 该编码方式的基本过程是先将内容以Base64格式编码为字符串，然后检查该结果字符串，将字符串中的加号 %2B 换成中划线 -,，并且将斜杠 %2F 换成下划线 _ 。)

标准的base64不适合在url中携带，因为存在+号和/号

解决方式可以将字符串中的加号`+`换成中划线`-`，并且将斜杠`/`换成下划线`_`

某项目中工具类：

```java
public final class Base64 {
    public Base64() {
    }

    public static byte[] decodeBase64(String str) {
        return org.apache.commons.codec.binary.Base64.decodeBase64(str);
    }

    public static String encodeBase64String(byte[] bs) {
        return org.apache.commons.codec.binary.Base64.encodeBase64String(bs);
    }

    public static boolean isArrayByteBase64(byte[] arrayOctect) {
        return org.apache.commons.codec.binary.Base64.isBase64(arrayOctect);
    }

    public static byte[] encode(byte[] binaryData) {
        return org.apache.commons.codec.binary.Base64.encodeBase64(binaryData);
    }

    public static byte[] encodeURL(byte[] binaryData) {
        return org.apache.commons.codec.binary.Base64.encodeBase64URLSafe(binaryData);
    }

    public static byte[] decode(byte[] base64Data) {
        return org.apache.commons.codec.binary.Base64.decodeBase64(base64Data);
    }
}
```

## jdk8之前commons-codec1.3

### 编码

```java
	static String base64Encode(String needEncodeStr){
        String base64encodedString = null;
        try {
            Base64 base64 = new Base64();
            byte[] encode = base64.encode(needEncodeStr.getBytes("utf-8"));
            base64encodedString = new String(encode);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return  base64encodedString;
    }
```

### 解码

```java
    static String base64Decode(String needDecodeStr){
        Base64 base64 = new Base64();
        byte[] base64decodedBytes;
        String res = null;
        try {
            base64decodedBytes = base64.decode(needDecodeStr.getBytes("utf-8"));
            res = new String(base64decodedBytes, "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return  res;
    }
```

## jdk8开始自带工具

### 编码

```java
    static String base64Encode(String needEncodeStr){
            String base64encodedString = null;
            try {
                base64encodedString = Base64.getEncoder().encodeToString(needEncodeStr.getBytes("utf-8"));
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            return  base64encodedString;
    }
```



### 解码

```java
    static String base64Decode(String needDecodeStr){
        byte[] base64decodedBytes = Base64.getDecoder().decode(needDecodeStr);
        String res = null;
        try {
            res = new String(base64decodedBytes, "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return  res;
    }

```

# MD5

MD5有16位和32位的区别，其中16位的结果位从32位结果中截取9-24位

需commons-codec包

```java
/**
 * md5加密工具
 * @param original
 * @return
 */
private String md5Crypt(String original) {
    return DigestUtils.md5Hex(original);
}
```

# RSA

RSA是一种非对称加密算法，其算法如下：

1. 选取任意两个不同大是素数p和q计算其乘积n
2. 另外令y=(p-1)(q-1)
3. 任意取一个大整数e满足e和y最大公约数为1，e将作为加密密钥，且1 < e < y
4. 取d，使其满足de=ky+1，d为解密密钥，故可看出其取决于e和y
5. 加密：密文c=(原文m^e)modn
6. 解密：原文m=(密文c^d)modn

破解难度在于，很难通过n来计算出y从而根据密钥之一算出另一个密钥

另外，公钥和私钥理论上都可以用来作加密和解密操作，但一般私钥用于解密和签名，其中签名操作其实是类加密的

在通常情况下，使用工具生成的公钥文件其中包含了公钥部分与n

- 公钥可以以多种格式存储在文件中，其中一些常见的格式包括PEM、DER、OpenSSH等。
- 在PEM格式中，公钥通常以"-----BEGIN PUBLIC KEY-----"开头，以"-----END PUBLIC KEY-----"结尾，中间是Base64编码的公钥数据。这个数据包含了公钥指数`E`和模数`N`的编码表示。
- 在DER格式中，公钥是以二进制形式表示的，并且通常使用ASN.1标准进行编码。虽然DER格式是二进制的，但在某些上下文中，它可能以Base64或十六进制形式进行表示和传输。
- OpenSSH格式是SSH协议中使用的公钥格式，它通常以"ssh-rsa"开头，后面跟着Base64编码的公钥数据。与PEM格式类似，这些数据也包含了公钥指数`E`和模数`N`的编码表示。