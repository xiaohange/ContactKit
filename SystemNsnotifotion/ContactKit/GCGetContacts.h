//
//  GCGetContacts.h
//  SystemNsnotifotion
//
//  Created by 韩俊强 on 16/3/24.
//  Copyright © 2016年 韩俊强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <UIKit/UIKit.h>

//检查系统版本
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@class ContactModel;

@interface GCGetContacts : NSObject

@property(nonatomic, assign)ABAddressBookRef addressBook;

@property (strong, nonatomic) NSDate *lastRefreshData;

@property (strong,nonatomic) CNContactStore  *contactStore;

@property (copy  ,nonatomic) NSMutableArray *phoneNumberArray;

+(GCGetContacts*)shareContact;
/**
 *   接收监听
 *  @return 注册通知@“contact”
 */

-(void)startListen;

/**
 *  停止监听
 *  @return 注册通知@“removeContact”
 */
- (void)stopListen;

/**
 *  授权
 *
 *  @return return value description
 */
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
/**
 *  通过block 获取所有联系人
 *
 *  @param success <#success description#>
 */
- (void)getAllContactFromDeviceSuccess:(void(^)(NSArray* dataAry))success;
/**
 *  添加联系方式到通讯录
 *
 *  @param name        联系人姓名
 *  @param phoneNumber 联系人电话
 *
 *  @return 是否添加成功
 */
- (void)addContactByUserName:(NSString *)name
                      andTel:(NSString *)tel
                     success:(void(^)(ContactModel*user))success
                     andFail:(void(^)(NSString*error))fail;
/**
 *  删除指定联系人
 *
 *  @param name 名字
 *  @return 是否添加成功
 */
-(BOOL)deletePeopleByName:(NSString *)name;

@end
