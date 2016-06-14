//
//  userInfo.m
//  baymax_marketing_iOS
//
//  Created by sky on 15/12/17.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import "userInfo.h"

@implementation userInfo
-(void)setUserID:(NSString *)userID{
    
    _userID = userID;
}


- (void)setUserDic:(NSDictionary *)userDic
{
    self.userID = [userDic objectForKey:@"uid"];
    self.leanCloudID = [userDic objectForKey:@"objectid"];
    self.userNickName = [userDic objectForKey:@"nickname"];
    self.remarkname = [[userDic objectForKey:@"remarkname"] isKindOfClass:[NSString class]]?[userDic objectForKey:@"remarkname"]:nil;
    self.sex = [[userDic objectForKey:@"sex"]integerValue];
    self.mobile = [userDic objectForKey:@"mobile"];
    self.headerImageUrl = [userDic objectForKey:@"headurl"];
    self.company = [userDic objectForKey:@"comname"];
    self.department = [userDic objectForKey:@"department"];
    self.position = [userDic objectForKey:@"position"];
    self.email = [userDic objectForKey:@"email"];
    self.area = [userDic objectForKey:@"area"];
    self.momentDic = [userDic objectForKey:@"lastpost"];
    self.type = [[userDic objectForKey:@"state"] integerValue];
    if ([userDic objectForKey:@"addtime"]) {
        self.addtime = [[userDic objectForKey:@"addtime"] integerValue];
    }
    
    self.NotLookHe = [[[userDic objectForKey:@"friendset"] objectForKey:@"viewhepost"] integerValue];
    self.NotLookMe = [[[userDic objectForKey:@"friendset"] objectForKey:@"viewmepost"] integerValue];
//    self.NotAcceptMsg = [[[userDic objectForKey:@"friendset"] objectForKey:@"isalert"] integerValue];
}

@end
