//
//  ContentViewController.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/25.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "ContentViewController.h"
#import <AFNetworking.h>

@interface ContentViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *Web;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.topItem.title = @"新闻";
   // self.navigationController.navigationBar.topItem.title = @"新闻资讯";
    _Web.opaque = NO;
    _Web.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated
{
//    _id_url = 322;
   // NSLog(@"%ld",_id_url);
    NSString *url = [NSString stringWithFormat:@"GetNewsContent?id=%ld",_id_url];
    url = URL_Head(url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            [_Web loadHTMLString:[(NSDictionary*)responseObject valueForKey:@"Contents"]baseURL:nil];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
   // NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [_Web loadRequest:request];
    
    
}
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
