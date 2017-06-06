//
//  OAContentViewController.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/30.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "OAContentViewController.h"
#import "HttpSection.h"

@interface OAContentViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end

@implementation OAContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* urlString = [NSString stringWithFormat:@"GetOANewsDetails?id=%@",_ID];
    
    
    [HttpSection url:urlString type:@"GET" body:nil block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         NSString* string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
     //   NSLog(@"%@",string);
        NSData* data2 = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableLeaves error:nil];
      //  NSDictionary* dic = [[NSDictionary alloc] initWithDictionary:jsonArray[0]];
        [_web loadHTMLString:[jsonArray objectForKey:@"Contents"] baseURL:nil];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
