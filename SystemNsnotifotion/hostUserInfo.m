//
//  hostUserInfo.m
//  baymax_marketing_iOS
//
//  Created by sky on 15/12/17.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import "hostUserInfo.h"
#import "userInfo.h"
//#import "GCUserDefaults.h"


@implementation hostUserInfo


+(instancetype)sharedInstance{
    static hostUserInfo* userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSString* localUserID = [[NSUserDefaults standardUserDefaults] localUserID];
//        if (localUserID) {
//            NSData* localData = [[NSUserDefaults standardUserDefaults] objectForKey:localUserID];
//            if (localData) {
//                userInfo = (hostUserInfo* )[NSKeyedUnarchiver unarchiveObjectWithData:localData];
//            }
//        }else{
//        userInfo = [[hostUserInfo alloc]init];
//        }
    });
    return userInfo;
}



-(void)clean{
    self.platform = 0;
    self.userID = nil;
    self.leanCloudID = nil;
    self.userNickName = nil;
    self.userName = nil;
    self.mobile = nil;
    self.userDesc = nil;
    self.headerImageUrl = nil;
    self.userNickName = nil;
    self.type = 0;
    self.unReadNums = 0;
    self.email = nil;
    self.area = nil;
    self.department = nil;
    self.company = nil;
    self.position = nil;
    self.sex = 0;
    self.platromArray = nil;
    [self save];
}
//
//- (void)setUserID:(NSString *)userID
//{
//    [super setUserID:userID];
//    [[NSUserDefaults standardUserDefaults] setLocalUserID:userID];
//}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithInteger:self.platform ] forKey:@"platform"];
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.leanCloudID forKey:@"leanCloudID"];
    [encoder encodeObject:self.userNickName forKey:@"userNickName"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.userDesc forKey:@"userDesc"];
    [encoder encodeObject:self.headerImageUrl forKey:@"headerImageUrl"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.unReadNums ] forKey:@"unReadNums"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.type ] forKey:@"type"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.sex ] forKey:@"sex"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.area forKey:@"area"];
    [encoder encodeObject:self.department forKey:@"department"];
    [encoder encodeObject:self.company forKey:@"company"];
    [encoder encodeObject:self.position forKey:@"position"];
    [encoder encodeObject:self.platromArray forKey:@"platromArray"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.platform = [[decoder decodeObjectForKey:@"platform"] integerValue];
        self.userID = [decoder decodeObjectForKey:@"userID"];
        self.leanCloudID = [decoder decodeObjectForKey:@"leanCloudID"];
        self.userNickName = [decoder decodeObjectForKey:@"userNickName"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.mobile = [decoder decodeObjectForKey:@"mobile"];
        self.userDesc = [decoder decodeObjectForKey:@"userDesc"];
        self.headerImageUrl = [decoder decodeObjectForKey:@"headerImageUrl"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.area = [decoder decodeObjectForKey:@"area"];
        self.department = [decoder decodeObjectForKey:@"department"];
        self.company = [decoder decodeObjectForKey:@"company"];
        self.position = [decoder decodeObjectForKey:@"position"];
        self.unReadNums = [[decoder decodeObjectForKey:@"unReadNums"] integerValue];
        self.type = [[decoder decodeObjectForKey:@"type"] integerValue];
        self.sex = [[decoder decodeObjectForKey:@"sex"] integerValue];
        self.platromArray = [decoder decodeObjectForKey:@"platromArray"];
    }
    return  self;
}

-(void)save{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
//    [[NSUserDefaults standardUserDefaults] saveObject:data forKey:userDefaults.localUserID];
}

- (void)setUserDic:(NSDictionary *)userDic
{
    _userDic = userDic;
    self.platform = 0;
    self.userID  = [userDic objectForKey:@"uid"];
    self.leanCloudID = [userDic objectForKey:@"objectid"];
    self.userNickName = [userDic objectForKey:@"nickname"];
    self.sex = [[userDic objectForKey:@"sex"]integerValue];
//    self.mobile = userDefaults.localUserID = [userDic objectForKey:@"mobile"];
    self.headerImageUrl = [userDic objectForKey:@"headurl"];
    self.company = [userDic objectForKey:@"comname"];
    self.department = [userDic objectForKey:@"department"];
    self.position = [userDic objectForKey:@"position"];
    self.email = [userDic objectForKey:@"email"];
    self.area = [userDic objectForKey:@"area"];
}


@end
