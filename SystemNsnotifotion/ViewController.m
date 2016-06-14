//
//  ViewController.m
//  SystemNsnotifotion
//
//  Created by 韩俊强 on 16/3/20.
//  Copyright © 2016年 韩俊强. All rights reserved.
//

#import "ViewController.h"
#import "GCGetContacts.h"
#import "ContactModel.h"
#import "SystemPrivileges.h"
#import "AlertTool.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelok;

@end

@implementation ViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // 测试1 －－ 系统相关检测状态
    // 系统权限检测入口 NO为未授权，YES未已授权
    //     BOOL isHave = [[SystemPrivileges shareSystemPrivileges]getSystemPrivilegesByPrivilegesType:Location];
    
    //测试3 －－ 提示框简单封装
    //    [[AlertTool shareAlertView]showAlertView:self title:@"提示" message:@"测试测试！！！！！" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" delegate:self confirm:^{
    //         NSLog(@"确定");
    //    } cancle:^{
    //         NSLog(@"取消");
    //    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMyLabel) name:@"contact" object:nil];
}
// 测试
- (IBAction)beginMonitorContact:(UIButton *)sender
{
    // 添加联系人到通讯录
//    [[GCGetContacts shareContact]addContactByUserName:@"HaRi" andTel:@"15903992805" success:^(ContactModel *user) {
//        NSLog(@"添加的联系人为：%@ %@",user.userName,user.mobileNumber);
//    } andFail:^(NSString *error) {
//        NSLog(@"添加失败：%@",error);
//    }];
    

    // 删除指定联系人(重明的也会被删除)
//    BOOL isSuccess = [[GCGetContacts shareContact]deletePeopleByName:@"HaRi"];
//    isSuccess?NSLog(@"DeleteSuccess"):NSLog(@"DeleteFail");
    

    // 通过Block获取所有联系人
//    [[GCGetContacts shareContact]getAllContactFromDeviceSuccess:^(NSArray *dataAry) {
//        NSLog(@"通讯录成员：%ld 人",dataAry.count);
//        for (ContactModel *user in dataAry) {
//            NSLog(@"%@  %@",user.userName,user.mobileNumber);
//        }
//    }];
    
}

- (void)changeMyLabel
{
    _labelok.text = @"发生变化";
    NSLog(@"11111111111111111111111111");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
