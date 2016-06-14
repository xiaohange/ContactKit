//
//  GCGetContact.m
//  purchasingManager
//
//  Created by Kris on 15/6/18.
//  Copyright (c) 2015年 郑州悉知. All rights reserved.
//

//SystemVersion
//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#import "GCGetContact.h"
//#import "hostUserInfo.h"
#import "NSString+GCString.h"
//hostUserInfo* hostUser;
@implementation GCGetContact


void contactChangeCallback (ABAddressBookRef addressBook,
                            CFDictionaryRef info,
                            void *context){
    
        NSDictionary *aa = (__bridge NSDictionary *)(info);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"change" object:aa];
}

+(GCGetContact *)shareContact
{
    static GCGetContact *contact = nil;
    static dispatch_once_t conPredicate;
    dispatch_once(&conPredicate, ^{
        
        contact = [[GCGetContact alloc]init];
    });
    return contact;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        // 注册通讯录监听
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactChange:) name:CNContactStoreDidChangeNotification object:nil];
        }else
        {
            ABAddressBookRegisterExternalChangeCallback(self.addressBook, contactChangeCallback, (__bridge void *)(self));
            // 注册通知
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change) name:@"change" object:nil];
        }
    }
    return self;
}

- (ABAddressBookRef)addressBook
{
    if (!_addressBook) {
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    return _addressBook;
}

- (CNContactStore *)contactStore
{
    if (!_contactStore) {
        
        _contactStore = [[CNContactStore alloc] init];
    }
    return _contactStore;
}

#pragma mark ----
#pragma mark ----  通讯录发生变化
- (void)contactChange:(id)sender {
    
    NSLog(@"发生变化");

    [[NSNotificationCenter defaultCenter] postNotificationName:@"aiosdhfahsdhf" object:nil];
  
//   //iOS9 通讯录变化
//    [self readContactsGetContactDataSuccess:^(NSArray *dataAry) {
//        
//        NSMutableArray *mAry = [NSMutableArray arrayWithArray:dataAry];
//        NSArray *contactAry =  [[friendDB sharedInstance] getContactsFromDB];
//
//        [mAry removeObjectsInArray:contactAry];
//        NSLog(@"%@",mAry);
////        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", contactAry];
////        
////        NSArray *aary = [dataAry filteredArrayUsingPredicate:thePredicate];
//        
//       
//    }];
    
}

- (void)change
{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:_lastRefreshData];
    if (timeInterval < 5) {
        //如果时间短
        return;
    }
    _lastRefreshData = [NSDate date];
    
//    [initWithUserData getContactArrayWithComplte:^(id sucDic) {
//        
//    } withError:^(NSError *error) {
//        
//    }];
}
/*
#pragma mark 通讯录变更后，遍历通讯录，找出变更的联系人信息
// 查找变化的联系人
- (userInfo *)changeOfContactBetweenDB:(NSArray*)dbArray andAddressBook:(NSArray*)bookArray
{
    //
    //    int way;
    //    if (dbArray.count>bookArray.count) {
    //        // 删除联系人
    //        way = 0;
    //    }else if (dbArray.count<bookArray.count){
    //        // 添加联系人
    //        way = 1;
    //    }else{
    //        // 修改联系人
    //        way = 2;
    //    }
    //    switch (way) {
    //        // 修改联系人
    //        case 2:
    //        {
    //            for (int i = 0; i<dbArray.count; i++) {
    //                userInfo *oldUserInfo = [dbArray objectAtIndex:i];
    //                for (userInfo *newUserInfo in bookArray) {
    //
    //                    if ([oldUserInfo.tel isEqualToString:newUserInfo.tel]) {
    //                        BOOL name = [oldUserInfo.userName isEqualToString:newUserInfo.userName];
    //                        if (!name) {
    //                            NSLog(@"newName = %@,oldName = %@",newUserInfo.userName,oldUserInfo.userName);
    //                            NSLog(@"newTel = %@,oldTel = %@",newUserInfo.tel,oldUserInfo.tel);
    //                            NSLog(@"%@___%d",newUserInfo.userName,__LINE__);
    //                            return newUserInfo;
    //                        }
    //                    }
    //
    //                    if ([oldUserInfo.userName isEqualToString:newUserInfo.userName]) {
    //                        BOOL tel = [oldUserInfo.tel isEqualToString:newUserInfo.tel];
    //
    //                        if (!tel) {
    //                            NSLog(@"%@___%d",newUserInfo.userName,__LINE__);
    //                            NSLog(@"newName = %@,oldName = %@",newUserInfo.userName,oldUserInfo.userName);
    //                            NSLog(@"newTel = %@,oldTel = %@",newUserInfo.tel,oldUserInfo.tel);
    //                            return newUserInfo;
    //                        }
    //                    }
    //                }
    //            }
    //
    //        }
    //            break;
    //        // 添加联系人
    //        case 1:
    //        {
    //            for (NSInteger i=0; i<bookArray.count; i++) {
    //                userInfo *newUser = [bookArray objectAtIndex:i];
    //                int flag = 0;
    //                for (userInfo *oldUser in dbArray) {
    //                    if (![newUser.tel isEqualToString:oldUser.tel]) {
    //                        flag++;
    //                    }
    //                }
    //                if (flag == dbArray.count) {
    //                    return newUser;
    //                }
    //            }
    //
    //        }
    //            break;
    //
    //        // 删除联系人
    //        case 0:
    //        {
    //            for (NSInteger i=0; i<bookArray.count; i++) {
    //                userInfo *newUser = [bookArray objectAtIndex:i];
    //                int flag = 0;
    //                for (userInfo *oldUser in dbArray) {
    //                    if (![newUser.tel isEqualToString:oldUser.tel]) {
    //                        flag++;
    //                    }
    //                }
    //                if (flag == bookArray.count) {
    //                    return newUser;
    //                }
    //            }
    //
    //        }
    //            break;
    //        default:
    //            break;
    //    }
    return nil;
}
 */
#pragma mark 获取通讯录联系人
-(BOOL)contactAuth{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        CNAuthorizationStatus authorStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        if (authorStatus != CNAuthorizationStatusAuthorized) {
            NSLog(@"未授权");
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置>隐私>通讯录打开本应用的权限设置" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            return NO;
        }else
        {
            return YES;
        }
    }else
    {
    ABAuthorizationStatus authorization = ABAddressBookGetAuthorizationStatus();
    if (authorization!=kABAuthorizationStatusAuthorized) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置>隐私>通讯录打开本应用的权限设置" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
        NSLog(@"未授权");
        return NO;
    }
    return YES;
    }
}

- (NSArray *)getAllContacts
{
//    if ([hostUser.mobile isEqualToString:@"18811111111"]) {
//        return nil;
//    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        
        return [self getContactSystemVersionGreaterThanIOS9];
    }else
    {
        return [self getContactSystemVersionLessThanIOS9];
    }
}

- (NSArray *)getContactSystemVersionLessThanIOS9
{
    if (![self contactAuth] || !self.addressBook) return nil;
    
    NSMutableArray* chongfu =[ NSMutableArray new];
    
    _phoneNumberArray = [NSMutableArray new];
    
    NSMutableArray *contactArray = [[NSMutableArray alloc]init];
    NSArray* results = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(self.addressBook);
    
    
    for(int i = 0;i < results.count;i++)
    {
        ABRecordRef person = (__bridge ABRecordRef)(results[i]);
        //读取firstname
        NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        //读取lastname
        NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        //读取公司
        NSString *company  = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonOrganizationProperty));
        // 电话多值
        ABMutableMultiValueRef temphones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        // email多值
        ABMutableMultiValueRef emailRecord = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        // 获取Email多值
        NSString* email;
        for (NSInteger i=0; i<ABMultiValueGetCount(emailRecord); i++) {
            NSString *temEm = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emailRecord, i);
            if ([temEm isValidEmail]) {
                email = email?[NSString stringWithFormat:@"%@,%@",email,temEm]:temEm; break;
            }
        }
        // 获取电话号码多值
        for (int j = 0; j < ABMultiValueGetCount(temphones); j++) {
            
            NSString *temPh = (__bridge NSString *)ABMultiValueCopyValueAtIndex(temphones, j);
            temPh = [temPh replaceCharcter:@"-" withCharcter:@""];
            temPh = [temPh replaceCharcter:@" " withCharcter:@""];
            if ([temPh length] == 14 && [[temPh substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"+86"]){
                temPh = [temPh substringWithRange:NSMakeRange(3, 11)];                                  }
            if([temPh isVAlidPhoneNumber]){
                // 拼接电话号码
                if (![chongfu containsObject:temPh]) {
                    [chongfu addObject:temPh];
                    userInfo *user = [[userInfo alloc]init];
                    user.email = email?:@"";
                    user.mobile = temPh;
                    user.company = company?:@"";
                    user.userName = [[NSString alloc] initWithFormat:@"%@%@",lastname?:@"",personName?:@""];
                    [contactArray addObject:user];
                    [_phoneNumberArray addObject:temPh];
                }
            }
        }
    }
    return contactArray;
}
- (void)addContactByUserName:(NSString *)name
                      andTel:(NSString *)tel success:(void (^)(userInfo *))success andFail:(void (^)(NSString *))fail
{
    // 创建联系人记录
    ABRecordRef personRecord = ABPersonCreate();
    // 错误信息
    CFErrorRef error;
    
    BOOL isAdd;
    if (!ABRecordSetValue(personRecord, kABPersonFirstNameProperty, (__bridge CFStringRef)name, &error)) {
        fail(@"添加联系人姓名失败");
        return;
    }
    // 电话号码
    ABMutableMultiValueRef phone = ABMultiValueCreateMutable(kABStringPropertyType);
    
    ABMultiValueIdentifier identifier;
    // 添加电话
    if (!ABMultiValueAddValueAndLabel(phone, (__bridge CFStringRef)tel, kABPersonPhoneMobileLabel, &identifier)) {
        fail(@"添加电话号码失败");
        return;
    }
    ABRecordSetValue(personRecord, kABPersonPhoneProperty, phone, &error);
    ABAddressBookAddRecord(self.addressBook, personRecord, &error);
    
    // 保存通讯录
    isAdd = ABAddressBookSave(self.addressBook, &error);
    if (isAdd) {
        userInfo *info = [[userInfo alloc]init];
        info.userName = name;
        info.mobile = tel;
        // 写入数据库
        //        friendDB *db = [friendDB sharedInstance];
        //        [db writUserInfoIntoDBFromAddressBook:@[info]];
        
        // 保存成功的回调
        success(info);
    }
}

- (NSArray *)getContactSystemVersionGreaterThanIOS9{

    if (![self contactAuth]) {
        return nil;
    }else
    {
 
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactFamilyNameKey,
                                         CNContactGivenNameKey,
                                         CNContactPhoneNumbersKey,
                                         CNContactEmailAddressesKey,
                                         CNContactPostalAddressesKey,
                                        CNContactOrganizationNameKey]];
        NSError *error = nil;
        NSMutableArray *nameArray = [[NSMutableArray alloc] init];
        NSMutableArray *phoneArray = [[NSMutableArray alloc]init];
        NSMutableArray *emaillARy = [[NSMutableArray alloc] init];
        NSMutableArray *companyNameAry = [[NSMutableArray alloc] init];
        // 是否 匹配联系人
        BOOL flag = [self.contactStore enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            //去除数字以外的所有字符
            NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
                                           invertedSet];
            NSString *strPhone = @"";
            if (contact.phoneNumbers.count>0) {
                strPhone  = [[[contact.phoneNumbers firstObject].value.stringValue componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
            }
            [phoneArray addObject:strPhone];
            NSString *name = @"";
            if ([NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName]) {
                name =  [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            }
            [nameArray addObject:name];
            NSString * emailAddress = @"暂无";
            if (contact.emailAddresses.count > 0) {
                
                CNLabeledValue *emaileVale = contact.emailAddresses[0];
                emailAddress = emaileVale.value;
            }
            [emaillARy addObject:emailAddress];
            NSString *comName = @"暂无";
            if (contact.organizationName.length > 0) {
                comName = contact.organizationName;
            }
            [companyNameAry addObject:comName];
        }];
        if (flag) {
            NSMutableArray *dataMAry = [NSMutableArray array];
            NSInteger aryCount = 0;
            for (NSString *userName in nameArray) {
                
               
                userInfo *user = [[userInfo alloc] init];
                user.userName = userName;
                user.mobile = phoneArray[aryCount];
                user.email = emaillARy[aryCount];
                user.company = companyNameAry[aryCount];
                [dataMAry addObject:user];
                aryCount++;
            }
            return dataMAry;
        }else {
            return nil;
        }
    }
}

#pragma mark 获取通讯录的回调

- (void)getAllContactFromDeviceSuccess:(void(^)(NSArray* dataAry))success
{
     __block typeof(self)weak_self = self;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            success([weak_self getAllContacts]);
        }];
    }else
    {
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        success([weak_self getAllContacts]);
    });
    }
}


@end
