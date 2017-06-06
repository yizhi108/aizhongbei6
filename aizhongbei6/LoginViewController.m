//
//  LoginViewController.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/25.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "ThridClass.h"
#import "UIViewController+BackButtonHandler.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *Forgebutton;
@property (weak, nonatomic) IBOutlet UIView *BackView;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.BackView.layer.shadowOpacity = 0.5;// 阴影透明度
    
    self.BackView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    
    self.BackView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    
    self.BackView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    //[self.view setBackgroundColor:[UIColor grayColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    _password.secureTextEntry = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if(_flag == 1)
    {
        _flag = 0;
        [self performSegueWithIdentifier:@"Register" sender:nil];
        //[self prepareForSegue:@"Register" sender:nil];
    }
}

- (IBAction)login:(id)sender {
    NSString* phone = _phone.text;
    NSString* password = _password.text;
    //NSLog(@"%ld",phone.length);
    if(phone.length != 11)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        [ThridClass SVProgressHUD_dismiss];
        return ;
        
        //
    }
    if(password.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        [ThridClass SVProgressHUD_dismiss];
        return ;
    }
    
    
    NSString *url = URL_Head(@"ValidateUser");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{
                          @"mobilePhone":phone,
                          @"password":password
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
     
        if([string isEqualToString:@"true"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
                [ThridClass SVProgressHUD_dismiss];
                
                [self token];
                
                
            });
        }else{
            [SVProgressHUD showErrorWithStatus:@"登陆失败"];
            [ThridClass SVProgressHUD_dismiss];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)token
{
    NSString *string = [NSString stringWithFormat:@"http://59.48.248.41:1020/inuc/token"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//[manager.requestSerializer setValue:@"value2" forHTTPHeaderField:@"key2"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *parameters = @{
                                 @"username":_phone.text,
                                 @"password":_password.text,
                                 @"grant_type":@"password"
                                 };
    
    [manager POST:string parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
       // NSLog(@"%@",responseObject);
        NSString *token  = [responseObject objectForKey:@"access_token"];
        NSString *token_type = [responseObject objectForKey:@"token_type"];
        
        [USERDEFA setValue:token forKey:TOKEN];
        [USERDEFA setValue:token_type forKey:TOKEN_TYPE];
        [USERDEFA setValue:@"Login" forKey:@"FLogin"];
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
    }];
    
    
}


- (IBAction)forget:(id)sender {
    
    
    NSString* phone = _phone.text;
    if(phone.length != 11 && [ThridClass isMobile:_phone.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        [ThridClass SVProgressHUD_dismiss];
        return ;
    }
    
    
    [_Forgebutton setTitle:@"已发送新密码，请稍后。" forState:UIControlStateNormal];
    _Forgebutton.enabled = NO;
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    NSString *url = URL_Head(@"RecoveryPassword");
    NSDictionary* parameters = @{
                                 @"mobilePhone":phone
                                 };
    //这里存在问题。不知道为什么，不调用这里的语句。
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"已发送新密码请稍后"];
            [ThridClass SVProgressHUD_dismiss];
        });
        
    } failure:nil];

}



- (IBAction)PhoneChange:(id)sender {
    [_Forgebutton setTitle:@"忘记密码" forState:UIControlStateNormal];
    _Forgebutton.enabled = YES;
}

-(BOOL) navigationShouldPopOnBackButton
{

    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
