//
//  ViewController.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/23.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <SDImageCache.h>
#import <SDCycleScrollView.h>
#import "CustomButton.m"


@interface ViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate>
{
    UIPageControl *pageControl;
    SDCycleScrollView *cycleScrollView;
    __weak IBOutlet UIView *BackView;
}



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 60, SCREENWIDTH, 200) delegate:self placeholderImage:[UIImage imageNamed:@"timg.jpg"]];
    [self.view addSubview:cycleScrollView];
    
    BackView.layer.shadowOpacity = 0.5;// 阴影透明度
    BackView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    BackView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    BackView.layer.shadowOffset  = CGSizeMake(1, 1);
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OAaction)];
    [BackView addGestureRecognizer:tapGesturRecognizer];
    
    [self web];
    
    
    UITextView *contentText = [[UITextView alloc] initWithFrame:CGRectMake(20, 400, SCREENWIDTH-40, 200)];
    contentText.text = @"更新时间：2017年5月8日\n版本号：v1.0.0";
    contentText.font = [UIFont systemFontOfSize:15];
//    contentText.backgroundColor = [UIColor blueColor];
    contentText.editable = NO;
    contentText.layer.shadowOpacity = 0.5;// 阴影透明度
    contentText.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    contentText.layer.shadowRadius = 3;// 阴影扩散的范围控制
    contentText.layer.shadowOffset  = CGSizeMake(1, 1);
    
    [self.view addSubview:contentText];
}




-(void)OAaction
{
    
    NSString* token = [USERDEFA objectForKey:TOKEN];
    if(token != nil && ![token isEqualToString:@""])
    {
        
        [self performSegueWithIdentifier:@"OASegue" sender:nil];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未登录" message:@"不能访问，请您登陆" preferredStyle:UIAlertControllerStyleAlert];
        
        //     [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.tabBarController.selectedIndex = 3;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }

    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title =@"iNUC";
}

-(void)web
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *string = URL_Head([NSString stringWithFormat:@"GetPictureNews?pageSize=6"]);
    
    
    
    [manager GET:string parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //   NSLog(@"%@",responseObject);
        NSArray *array =[[NSArray alloc] initWithArray:(NSArray*)responseObject];
//        NSLog(@"%@",array[0]);
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc] init];
        for (int i = 0; i<6; i++) {
           // [(NSDictionary*)array[0] valueForkey:@"TitlePicture"];
            
            [imagesURLStrings addObject:[array[i] valueForKey:@"TitlePicture"]];
            
        }
        cycleScrollView.imageURLStringsGroup = imagesURLStrings;
//        NSLog(@"%@",imagesURLStrings);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
