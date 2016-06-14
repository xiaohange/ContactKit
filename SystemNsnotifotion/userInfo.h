//
//  userInfo.h
//  baymax_marketing_iOS
//
//  Created by sky on 15/12/17.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userInfo : NSObject

@property (nonatomic, assign)   NSInteger platform;     //用户平台  暂时没用

@property (nonatomic, copy)     NSString* userID;
@property (nonatomic, copy)     NSString* leanCloudID;
@property (nonatomic, copy)     NSString* userName;
@property (nonatomic, copy)     NSString* userDesc;//
@property (nonatomic, copy)     NSString* mobile;
@property (nonatomic, copy)     NSString* tel;
@property (nonatomic, copy)     NSString* headerImageUrl;
@property (nonatomic, copy)     NSString* userNickName;
@property (nonatomic, assign)   NSInteger type;
@property (nonatomic, assign)   NSInteger unReadNums;

@property (nonatomic, copy)     NSString* remarkname; // 备注
@property (nonatomic, copy)     NSString* area; //区域


@property (nonatomic, copy)     NSString* email;
@property (nonatomic, copy)     NSString* department;
@property (nonatomic, copy)     NSString* company;
@property (nonatomic, copy)     NSString* position;//职位
@property (nonatomic, assign)   NSInteger addtime; //添加时间

@property (nonatomic, assign)   NSInteger sex;       //性别  1男  2女


@property (copy  ,nonatomic)    NSArray *platromArray;//三方平台信息



@property (assign,nonatomic) BOOL  NotLookMe;
@property (assign,nonatomic) BOOL  NotLookHe;
@property (assign,nonatomic) BOOL  NotAcceptMsg;




@property (assign, nonatomic)   NSInteger level;        //等级 暂时没用
@property (assign, nonatomic)   NSInteger credit;       //信用 暂时没用


//最近的一条朋友圈
@property (nonatomic, copy)NSDictionary* momentDic;

- (void)setUserDic:(NSDictionary *)userDic;

//V1.2
@property (assign,nonatomic) BOOL  rowSelected;//是否选中

@end
