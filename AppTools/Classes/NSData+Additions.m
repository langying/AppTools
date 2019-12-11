//
//  NSData+Cryptor.m
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-11.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import "NSData+Additions.h"

@implementation NSData (Additions)

-(NSString*)md5 {
    if ([self length] <= 0) {
        return nil;
    }
    unsigned char result[32];
    CC_MD5([self bytes], (CC_LONG)[self length], result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

-(NSString*)hexString {
    NSString* str = [self description];
    str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
    return str;
}

-(NSString*)stringWithEncoding:(NSStringEncoding)encoding {
    return [NSString.alloc initWithData:self encoding:encoding];
}

-(NSData*)AES256Decrypt:(NSData*)key {
    NSData* result = nil;
    size_t decryptedSize = 0;
    size_t bufferSize = self.length + kCCBlockSizeAES128;
    void* buffer = malloc(bufferSize);
    CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, key.bytes, kCCKeySizeAES256, NULL, self.bytes, self.length, buffer, bufferSize, &decryptedSize);
    if (kCCSuccess == status) {
        result = [NSData dataWithBytes:buffer length:decryptedSize];
    } else {
        NSLog(@"aesDecrypt:forKey(%@,%@)", self, key);
    }
    
    free(buffer);
    return result;
}

-(NSData*)AES256Encrypt:(NSData*)key {
    NSData* result = nil;
    size_t encryptedSize = 0;
    size_t bufferSize = self.length + kCCBlockSizeAES128;
    void* buffer = malloc(bufferSize);
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, key.bytes, kCCKeySizeAES256, NULL, self.bytes, self.length, buffer, bufferSize, &encryptedSize);
    if (kCCSuccess == status) {
        result = [NSData dataWithBytes:buffer length:encryptedSize];
    } else {
        NSLog(@"aesEncrypt:forKey(%@,%@)", self, key);
    }
    
    free(buffer);
    return result;
}

- (id)objectFromJSONString {
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:nil];
}

@end
