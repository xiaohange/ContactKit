//
//  hostUserInfo.h
//  baymax_marketing_iOS
//
//  Created by sky on 15/12/17.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import "userInfo.h"

@interface hostUserInfo : userInfo

@property (nonatomic, assign)   BOOL  canChat;
@property (nonatomic, assign)   BOOL  unUse;


@property (copy  ,nonatomic) NSDictionary *userDic;


+(instancetype)sharedInstance;


//保存一下 每次更新或者重新登录后 需要执行此操作
-(void)save;



//用户登出 更改用户信息
-(void)clean;

@end
