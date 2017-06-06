//
//  OAViewController.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/30.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "OAViewController.h"
#import <SVProgressHUD.h>
#import <SVPullToRefresh.h>
#import "HttpSection.h"
#import "OADish.h"
#import "OATableViewCell.h"
#import "OAContentViewController.h"
#import "ThridClass.h"

@interface OAViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* array;//type=2&pageSize=10&pageIndex=1
    NSInteger typeWeb;
    NSInteger pageSize;
    NSInteger pageIndex;
    NSMutableArray* DishArray;
    NSInteger flag;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UINavigationItem *nav;

@end

@implementation OAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    typeWeb = 1;
    pageIndex = 1;
    pageSize = 10;
    _nav.title = @"校内新闻";
    [_table registerNib:[UINib nibWithNibName:@"OATableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [_table addPullToRefreshWithActionHandler:^{
        
        pageIndex = 1;
       // NSString* body = [NSString stringWithFormat:@"type=%ld&pageSize=%ld&pageIndex=%ld",typeWeb,pageSize,pageIndex];
        NSString* urlString = [NSString stringWithFormat:@"GetOANews?type=%ld&pageSize=%ld&pageIndex=%ld",typeWeb,pageSize,pageIndex];
        [HttpSection url:urlString type:@"GET" body:nil block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString* string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            NSData* data2 = [string dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableLeaves error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                array = [[NSMutableArray alloc] initWithArray:jsonArray];
                DishArray = [[NSMutableArray alloc] init];
                for (NSDictionary* dic in array) {
                    OADish* dish = [[OADish alloc] initWithDic:dic];
                    [DishArray addObject:dish];
                }
                
                [self refreshShouldEnd];
            });
                
        }];
        
    }];
    
    [_table addInfiniteScrollingWithActionHandler:^{
        pageIndex ++;
         NSString* urlString = [NSString stringWithFormat:@"GetOANews?type=%ld&pageSize=%ld&pageIndex=%ld",typeWeb,pageSize,pageIndex];
        [HttpSection url:urlString type:@"GET" body:nil block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString* string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
          
            NSData* data2 = [string dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableLeaves error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                array = [[NSMutableArray alloc] initWithArray:jsonArray];
                for (NSDictionary* dic in array) {
                    OADish* dish = [[OADish alloc] initWithDic:dic];
                    [DishArray addObject:dish];
                    
                }
                
                [self infinitRefreshEnd];
            });
            
        }];
        
        
    }];
    
    [_table triggerPullToRefresh];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转，传值
    flag = indexPath.row;
    [self performSegueWithIdentifier:@"OAContent" sender:nil];
    
    //    self.performSegueWithIdentifier("showAgeTableView", sender: nil)
}

- (IBAction)change:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"校内新闻" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        typeWeb = 1;
        _nav.title = @"校内新闻";
        [_table triggerPullToRefresh];
    }];
    
    UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"校内公告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _nav.title = @"校内公告";
        typeWeb = 2;
        [_table triggerPullToRefresh];
        
    }];
    
    UIAlertAction* alertAction4 = [UIAlertAction actionWithTitle:@"高教动态" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        typeWeb = 3;
        _nav.title = @"高教动态";
        [_table triggerPullToRefresh];
    }];
    UIAlertAction* alertAction5 = [UIAlertAction actionWithTitle:@"学术报告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _nav.title = @"学术报告";
        typeWeb = 4;
        [_table triggerPullToRefresh];
    }];
    UIAlertAction* alertAction6 = [UIAlertAction actionWithTitle:@"会议纪要" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        typeWeb = 5;
        _nav.title = @"会议纪要";
        [_table triggerPullToRefresh];
    }];
    UIAlertAction* alertAction7 = [UIAlertAction actionWithTitle:@"领导讲话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _nav.title = @"领导讲话";
        typeWeb = 6;
        [_table triggerPullToRefresh];
    }];
    
    
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [alertController addAction:alertAction3];
    [alertController addAction:alertAction4];
    [alertController addAction:alertAction5];
    [alertController addAction:alertAction6];
    [alertController addAction:alertAction7];
    
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OAContent"]) {
        
        OAContentViewController* content = (OAContentViewController*)segue.destinationViewController;
        OADish* dish = DishArray[flag];
        content.ID = dish.ID;
        
    }
    
    
}

- (void)refreshShouldEnd
{
    //
    [_table reloadData];
    [_table.pullToRefreshView stopAnimating];
}

-(void)infinitRefreshEnd
{
    [_table reloadData];
    [_table.infiniteScrollingView stopAnimating];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OATableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell setWithModel:DishArray[indexPath.row]];
    return  cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return DishArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OADish* dish =DishArray[indexPath.row];
    NSString* content = [dish title];
    CGFloat height = [ThridClass heightForString:content fontSize:17 andWidth:298];
    
    return 50+height;
}

@end
