//
//  NSString+GCString.h
//  GongChangSupplier
//
//  Created by 碧天 杨 on 14-8-1.
//  Copyright (c) 2014年 郑州悉知信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (GCString)

-(BOOL)isBlank;
-(BOOL)isValid;
- (NSString *)removeWhiteSpacesFromString;


- (NSUInteger)countNumberOfWords;
- (BOOL)containsString:(NSString *)subString;
- (BOOL)isBeginsWith:(NSString *)string;
- (BOOL)isEndssWith:(NSString *)string;

- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end;
- (NSString *)addString:(NSString *)string;
- (NSString *)removeSubString:(NSString *)subString;

- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndLetters;
- (BOOL)isInThisarray:(NSArray*)array;

+ (NSString *)getStringFromArray:(NSArray *)array;
- (NSArray *)getArray;

+ (NSString *)getMyApplicationVersion;
+ (NSString *)getMyApplicationName;

- (NSData *)convertToData;
+ (NSString *)getStringFromData:(NSData *)data;

- (BOOL)isValidEmail;
- (BOOL)isVAlidPhoneNumber;
- (BOOL)isValidUrl;
- (BOOL)isChinese;
- (BOOL)isChineseAndLetter;
- (NSString *)convertEmptyStringToCustomString;

-(NSString* )headImageSize;
@end
