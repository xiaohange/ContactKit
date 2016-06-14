//
//  GCGetContacts.m
//  SystemNsnotifotion
//
//  Created by 韩俊强 on 16/3/24.
//  Copyright © 2016年 韩俊强. All rights reserved.
//

#import "GCGetContacts.h"
#import "ContactModel.h"
BOOL isHave = NO;
@implementation GCGetContacts

void contactChangeCallback (ABAddressBookRef addressBook,
                            CFDictionaryRef info,
                            void *context){
    
    NSDictionary *aa = (__bridge NSDictionary *)(info);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"change" object:aa];
}

+(GCGetContacts *)shareContact
{
    static GCGetContacts *contact = nil;
    static dispatch_once_t conPredicate;
    dispatch_once(&conPredicate, ^{
        
        contact = [[GCGetContacts alloc]init];
        
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
        }else{
            ABAddressBookRegisterExternalChangeCallback(self.addressBook, contactChangeCallback, (__bridge void *)(self));
            // 注册通知
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(contactChange:) name:@"change" object:nil];
        }
    }
    return self;
}

 //监控通讯录变化
- (void)startListen
{
   [[GCGetContacts shareContact]getAllContacts];
}

- (void)stopListen
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"change" object:nil];
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

#pragma mark ---- 通讯录发生变化
- (void)contactChange:(id)sender {
    if (isHave) {
        return;
    }else{
        isHave = YES;
     
        // 只取一次
        [[NSNotificationCenter defaultCenter] postNotificationName:@"contact" object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isHave = NO;
        });
    }
}

#pragma mark ---- 获取通讯录联系人
// 授权
-(BOOL)contactAuth{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        CNAuthorizationStatus authorStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
            if (authorStatus != CNAuthorizationStatusAuthorized) {
            NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-通讯录“选项中，允许%@访问你的通讯录。",NSLocalizedString(@"本App",@"GMChatDemo")];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
//            NSURL*url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            [[UIApplication sharedApplication]openURL:url];
            
            return NO;
        }else{
            return YES;
        }
    }else{
        ABAuthorizationStatus authorization = ABAddressBookGetAuthorizationStatus();
        if (authorization!=kABAuthorizationStatusAuthorized) {
            [self changeAuthorStatus];
            NSLog(@"未授权");
            return NO;
        }
        return YES;
    }
}

// 提示用户设置
- (void)changeAuthorStatus
{
    NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-允许%@访问您的通讯录",NSLocalizedString(@"AppName",@"GMChatDemo")];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:tips delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
}

- (NSArray *)getAllContacts
{
  return  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")?[self getContactSystemVersionGreaterThanIOS9]:[self getContactSystemVersionLessThanIOS9];
}

- (NSArray *)getContactSystemVersionLessThanIOS9
{
    if (![self contactAuth] || !self.addressBook) return nil;
    
    NSMutableArray* chongfu = [NSMutableArray array];
    
    _phoneNumberArray = [NSMutableArray array];
    
    NSMutableArray *contactArray = [[NSMutableArray alloc]init];
    NSArray* results = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(self.addressBook);
    
    
    for(int i = 0;i < results.count;i++){
        
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
            if ([self validateEmail:temEm]) {
                email = email?[NSString stringWithFormat:@"%@,%@",email,temEm]:temEm; break;
            }
        }
        // 获取电话号码多值
        for (int j = 0; j < ABMultiValueGetCount(temphones); j++) {
            
            NSString *temPh = (__bridge NSString *)ABMultiValueCopyValueAtIndex(temphones, j);
            temPh = [temPh stringByReplacingOccurrencesOfString:@"-" withString:@""];
            temPh = [temPh stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if ([temPh length] == 14 && [[temPh substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"+86"]){
                temPh = [temPh substringWithRange:NSMakeRange(3, 11)];                                  }
            if([self validateMobile:temPh]){
                // 拼接电话号码
                if (![chongfu containsObject:temPh]) {
                    [chongfu addObject:temPh];
                    
                    // 存储用户信息
                    ContactModel *user = [[ContactModel alloc]init];
                    user.email = email?:@"";
                    user.mobileNumber = temPh;
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

// Is Valid Email
- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
// Is Valid Phone
- (BOOL)validateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^(1)\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (NSArray *)getContactSystemVersionGreaterThanIOS9{
    
    if (![self contactAuth]) {
        return nil;
    }else{
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
            
                            // 用户对象
                            ContactModel *user = [[ContactModel alloc]init];
                            user.userName = userName;
                            user.mobileNumber = phoneArray[aryCount];
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
    }else{
        ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
            success([weak_self getAllContacts]);
        });
    }
}

- (void)addContactByUserName:(NSString *)name
                      andTel:(NSString *)tel success:(void (^)(ContactModel *user))success andFail:(void (^)(NSString *error))fail
{
    // 创建联系人记录
    ABRecordRef personRecord = ABPersonCreate();
    // 错误信息
    CFErrorRef error;
    
    BOOL isAdd;
    if (!ABRecordSetValue(personRecord, kABPersonFirstNameProperty, (__bridge CFStringRef)name, &error)) {
        fail(@"添加联系人姓名失败");
        [self stopListen]; // 取消监听
        return;
    }
    // 电话号码
    ABMutableMultiValueRef phone = ABMultiValueCreateMutable(kABStringPropertyType);
    
    ABMultiValueIdentifier identifier;
    // 添加电话
    if (!ABMultiValueAddValueAndLabel(phone, (__bridge CFStringRef)tel, kABPersonPhoneMobileLabel, &identifier)) {
        fail(@"添加电话号码失败");
        [self stopListen]; // 取消监听
        return;
    }
    ABRecordSetValue(personRecord, kABPersonPhoneProperty, phone, &error);
    ABAddressBookAddRecord(self.addressBook, personRecord, &error);
    
    // 保存通讯录
    isAdd = ABAddressBookSave(self.addressBook, &error);
    if (isAdd) {
        ContactModel *info = [[ContactModel alloc]init];
        info.userName = name;
        info.mobileNumber = tel;
        // 在此处可以写入本地数据库
        
        // 保存成功的回调
        success(info);
    }else{
        [self stopListen]; // 取消监听
    }
}

//删除联系人
- (BOOL)deletePeopleByName:(NSString *)name
{
    BOOL deleteSuc;
    deleteSuc = NO;
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = ABAddressBookCreate();
    NSArray* tmpPersonArray = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    for(id tmpPerson in tmpPersonArray)
    {
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        NSString* tmpLastName  = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        NSString* tmpFullName = [NSString stringWithFormat: @"%@%@", [tmpFirstName lowercaseString], [tmpLastName lowercaseString]];

        //删除联系人
        if([tmpFullName isEqualToString:name]||[tmpFirstName isEqualToString:name]||[tmpLastName isEqualToString:name])
        {
            ABAddressBookRemoveRecord(tmpAddressBook, (__bridge ABRecordRef)(tmpPerson), nil);
            deleteSuc = YES;
        }
    }
    //保存电话本
    ABAddressBookSave(tmpAddressBook, nil);
    //释放内存
    CFRelease(tmpAddressBook);
    if (!deleteSuc) {
        [self stopListen];
    }
    return deleteSuc;
}
@end