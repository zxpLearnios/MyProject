//
//  String+extension.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/15.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit
import Foundation

//enum CryptoAlgorithm {
//    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
//    
//    var HMACAlgorithm: CCHmacAlgorithm {
//        var result: Int = 0
//        switch self {
//        case .MD5:      result = kCCHmacAlgMD5
//        case .SHA1:     result = kCCHmacAlgSHA1
//        case .SHA224:   result = kCCHmacAlgSHA224
//        case .SHA256:   result = kCCHmacAlgSHA256
//        case .SHA384:   result = kCCHmacAlgSHA384
//        case .SHA512:   result = kCCHmacAlgSHA512
//        }
//        return CCHmacAlgorithm(result)
//    }
//    
//    var digestLength: Int {
//        var result: Int32 = 0
//        switch self {
//        case .MD5:      result = CC_MD5_DIGEST_LENGTH
//        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
//        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
//        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
//        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
//        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
//        }
//        return Int(result)
//    }
//}


extension String{

    /**
     *  去掉前后所有的空格
     */
    static func deleteBlankFromHeadAndTail(primordailStr str:String) -> String {
        let newStr = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        return newStr
    }

    
    
//    var md5: String! {
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
//        
//        CC_MD5(str!, strLen, result)
//        
//        //        return stringFromBytes(result, length: digestLen)
//        
//        let hash = NSMutableString()
//        for i in 0..<digestLen {
//            //            hash.appendFormat("%02x", result[i])
//            // 在QOne项目中，要改为大写的16进制，否则会报错“签名失败”！
//            hash.appendFormat("%02X", result[i])
//        }
//        
//        result.dealloc(digestLen)
//        
//        return String(format: hash as String)
//    }
//    
//    var sha1: String! {
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
//        CC_SHA1(str!, strLen, result)
//        return stringFromBytes(result, length: digestLen)
//    }
//    
//    var sha256String: String! {
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
//        CC_SHA256(str!, strLen, result)
//        return stringFromBytes(result, length: digestLen)
//    }
//    
//    var sha512String: String! {
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = Int(CC_SHA512_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
//        CC_SHA512(str!, strLen, result)
//        return stringFromBytes(result, length: digestLen)
//    }
//    
//    func stringFromBytes(bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String{
//        let hash = NSMutableString()
//        for i in 0..<length {
//            hash.appendFormat("%02x", bytes[i])
//        }
//        bytes.dealloc(length)
//        return String(format: hash as String)
//    }
//    
//    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = Int(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = algorithm.digestLength
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
//        let keyStr = key.cStringUsingEncoding(NSUTF8StringEncoding)
//        let keyLen = Int(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        
//        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
//        
//        let digest = stringFromResult(result, length: digestLen)
//        
//        result.dealloc(digestLen)
//        
//        return digest
//    }
//    
//    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
//        let hash = NSMutableString()
//        for i in 0..<length {
//            hash.appendFormat("%02x", result[i])
//        }
//        return String(hash)
//    }
    
    
    
}
