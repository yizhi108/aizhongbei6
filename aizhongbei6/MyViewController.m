//
//  MyViewController.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/25.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "MyViewController.h"
#import "LoginViewController.h"
#import "HttpSection.h"
#import <UIImageView+WebCache.h>

@interface MyViewController ()
{
    int flag;
    NSString*token;
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backView.layer.shadowOpacity = 0.5;// 阴影透明度
    
    self.backView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    
    self.backView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    
    self.backView.layer.shadowOffset  = CGSizeMake(1, 1);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title =@"我";
    [self.tabBarController setSelectedIndex:4];
    [self HeadViewInit];
}

-(void)HeadViewInit
{
    //[self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_headView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 60, 60)];
    //imageView.backgroundColor = [UIColor redColor];
   // [imageView setImage:[[UIImage alloc] initWithContentsOfFile:@"face.png"]];
    [imageView setImage:[UIImage imageNamed:@"face.png"]];
    [_headView addSubview:imageView];
    
    token = [USERDEFA objectForKey:TOKEN];
    if(token != nil && ![token isEqualToString:@""])
    {// 已经登录
        
        
       
        [HttpSection url:@"GetPersonnel" type:@"POST" body:nil block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString* string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",string);
            NSData* data2 = [string dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableLeaves error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(jsonDict[@"PictureUrl"]!=[NSNull null])
                {
                    [imageView sd_setImageWithURL:jsonDict[@"PictureUrl"] placeholderImage:[UIImage imageNamed:@"face.png"]];
                }
                
                UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 200, 20)];
                label.text = [NSString stringWithFormat:@"手机号:%@",jsonDict[@"MobilePhone"]];
                
                [_headView addSubview:label];
                
            });
            
        }];
       
        
        
        /*
         imgView.backgroundColor = [UIColor redColor];//因为没有设置image属性，为了显示出图片覆盖区域
         imgView.userInteractionEnabled=YES;
         UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
         [imgView addGestureRecognizer:singleTap];
         [singleTap release];
         */
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Personal)];
        [imageView addGestureRecognizer:singleTap];
//        [singleTap ]
       // [singleTap ]
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(320, 30, 50, 30)];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitle:@"退出" forState: UIControlStateNormal];
        [button addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:button];
        
        
    }else{
        //未登录
        
        UIButton* loginButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 30, 100, 50)];
        [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        loginButton.backgroundColor = [UIColor redColor];
        [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:loginButton];
        
        UIButton* registerButton = [[UIButton alloc] initWithFrame:CGRectMake(222, 30, 100, 50)];
        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        registerButton.backgroundColor = [UIColor greenColor];
        [registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:registerButton];
        
    }
    
    
}

-(void)registerAction
{
    flag = 1;
//    [self performSegueWithIdentifier:@"Login" sender:nil];
    LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    login.flag = 1;
    [self.navigationController pushViewController:login animated:NO];

}

-(void)Personal
{
    [self performSegueWithIdentifier:@"personal" sender:nil];
    
}

-(void)quit
{
    
    [USERDEFA setValue:@"" forKey:TOKEN];
    [USERDEFA setValue:@"" forKey:TOKEN_TYPE];
    //[self.view layoutIfNeeded];
    [self HeadViewInit];
}

-(void)loginAction
{
    flag = 0;
    [self performSegueWithIdentifier:@"Login" sender:nil];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(flag == 1 && [segue.identifier isEqualToString:@"Login"])
    {
        LoginViewController *Login = segue.destinationViewController;
        Login.flag = 1;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
