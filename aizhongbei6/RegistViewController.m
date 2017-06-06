//
//  RegistViewController.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/25.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "RegistViewController.h"
#import "LoginViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "ThridClass.h"

@interface RegistViewController ()
{
    NSString* sexString;
    __block int timeout;//倒计时时间
}

//@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (weak, nonatomic) IBOutlet UITextField *validate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSingle;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self.view setBackgroundColor:[UIColor grayColor]];
    _button1.clipsToBounds = YES;
    _button1.layer.cornerRadius = 5;
    _RegisterButton.clipsToBounds = YES;
    _RegisterButton.layer.cornerRadius = 5;
    sexString = @"男";
    _password.secureTextEntry = YES;
    _password2.secureTextEntry = YES;
}


- (IBAction)btn:(id)sender {
    NSString *Phonenumber = _phone.text;
  //  NSLog(@"%ld",Phonenumber.length);
    if(Phonenumber.length != 11  && [ThridClass isMobile:_phone.text] == false)
    {
        
     //   [SVProgressHUD dismissWithDelay:1.5f];
        //setDefaultMaskType
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
       //
        [ThridClass SVProgressHUD_dismiss];
        return ;
    }
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters =@{
                                @"mobilePhone":Phonenumber
                                };
    
    NSString *url = URL_Head(@"GetVerificationCode");
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
       // NSLog(@"%@",string);34
        if([string  isEqual: @"false"])
        {
            [SVProgressHUD showErrorWithStatus:@"该手机号已经被注册"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error  %@",error);
    }];
    
    timeout=60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [_button1 setTitle:@"发送验证码" forState:UIControlStateNormal];
                _button1.backgroundColor = [UIColor colorWithRed:26/255.0 green:152/255.0 blue:252/255.0 alpha:1];
                _button1.userInteractionEnabled = YES;
                
                
            });
            
            
        }else{
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 61;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
               
                
                [_button1 setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                
                _button1.backgroundColor = [UIColor colorWithRed:26/255.0 green:152/255.0 blue:252/255.0 alpha:1];
                
                _button1.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Register:(id)sender {
    NSString *mobilePhoneString = self.phone.text;
    NSString *Passowrd1String = self.password.text;
    NSString *Passowrd2String = self.password2.text;
    NSString *codeString = self.validate.text;
    NSString *nicknameString = self.name.text;
    
    
    if(mobilePhoneString.length == 0 || Passowrd1String.length == 0 || Passowrd2String.length == 0 || codeString.length == 0 || nicknameString == 0 || nicknameString == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"任意项不能为空"];
        [ThridClass SVProgressHUD_dismiss];
        return ;
    }
    
    if(![Passowrd2String isEqualToString:Passowrd1String])
    {
        
        [SVProgressHUD showErrorWithStatus:@"两次密码不同"];
        [ThridClass SVProgressHUD_dismiss];
        return ;
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlString = URL_Head(@"CreateUser");
    NSDictionary *parameters = @{
                                 @"mobilePhone":mobilePhoneString,
                                 @"password":Passowrd1String,
                                 @"code":codeString,
                                 @"nickname":nicknameString,
                                 @"sex":sexString
                                 };
   // NSLog(@"%@",parameters);
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if([string isEqualToString:@"验证码错误"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"验证码错误"];
                [ThridClass SVProgressHUD_dismiss];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                [ThridClass SVProgressHUD_dismiss];
                //
                [self performSelector:@selector(back) withObject:nil afterDelay:1.5];
               
                
            });
            
        }
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)back
{
    LoginViewController* vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    vc.phone.text = self.phone.text;
   // [self.navigationController popToRootViewController animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)phoneChange:(id)sender {
    timeout = 0;
}




@end
