//
//  ContactModel.h
//  SystemNsnotifotion
//
//  Created by 韩俊强 on 16/6/14.
//  Copyright © 2016年 韩俊强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property (nonatomic, copy) NSString *userName;     // 姓名

@property (nonatomic, copy) NSString *mobileNumber; // 电话

@property (nonatomic, copy) NSString *email;        // 邮箱

@property (nonatomic, copy) NSString *company;      // 公司

@end
