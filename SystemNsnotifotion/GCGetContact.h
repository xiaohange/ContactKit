//
//  GCGetContact.h
//  purchasingManager
//
//  Created by Kris on 15/6/18.
//  Copyright (c) 2015年 郑州悉知. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "userInfo.h"
@interface GCGetContact : NSObject


@property(nonatomic, assign)ABAddressBookRef addressBook;

@property (strong, nonatomic) NSDate *lastRefreshData;

@property (strong,nonatomic) CNContactStore  *contactStore;

@property (copy  ,nonatomic) NSMutableArray *phoneNumberArray;


+(GCGetContact*)shareContact;

// 查找通讯录信息变化的联系人
//- (userInfo *)changeOfContactBetweenDB:(NSArray*)dbArray andAddressBook:(NSArray*)bookArray;

-(BOOL)contactAuth;

// 获取通讯录所有联系人
- (NSArray *)getAllContacts;

/**
 *  获取系统通讯录 系统版本低于ios9
 *
 *  @return <#return value description#>
 */
- (NSArray *)getContactSystemVersionLessThanIOS9;
/**
 *  获取系统通讯录 系统版本高于ios9
 *
 *  @return <#return value description#>
 */
- (NSArray *)getContactSystemVersionGreaterThanIOS9;

//添加联系人
- (void)addContactByUserName:(NSString *)name
                      andTel:(NSString *)tel
                     success:(void(^)(userInfo* ))success
                     andFail:(void(^)(NSString* ))fail;

/**
 *  通过block 获取所有联系人
 *
 *  @param success <#success description#>
 */
- (void)getAllContactFromDeviceSuccess:(void(^)(NSArray* dataAry))success;

@end
