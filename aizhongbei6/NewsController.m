//
//  NewsController.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/23.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "NewsController.h"
#import "MyTableViewCell.h"
#import <SVPullToRefresh.h>
#import <AFNetworking.h>
#import "MainCellDish.h"
#import "ContentViewController.h"
#import "ThridClass.h"

@interface NewsController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* tableArray;
    NSMutableArray* DishArray;
    NSInteger flag;
    
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation NewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tableArray = [[NSMutableArray alloc] init];
    [self TableInIt];
   
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"新闻";
    [_table triggerPullToRefresh];
}
-(void)TableInIt
{
     [_table registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    const int pageSize = 15;
    __block int pageIndex = 1;
  //  [_table setRowHeight:100];
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [_table addPullToRefreshWithActionHandler:^{
        pageIndex = 1;
        NSString* urlString = [NSString stringWithFormat:@"GetNews?pageIndex=%d&pageSize=%d",pageIndex,pageSize];
        urlString = URL_Head(urlString);
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            tableArray = [[NSMutableArray alloc] init];
            tableArray = (NSMutableArray*)responseObject;
            DishArray = [[NSMutableArray alloc] init];
            for (NSDictionary* dic in tableArray) {
                MainCellDish *model = [[MainCellDish alloc] initWithDic:dic];
                [DishArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshShouldEnd];
            });
            
                
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
    }];
    

    
    [_table addInfiniteScrollingWithActionHandler:^{
        pageIndex ++;
        NSString* urlString = [NSString stringWithFormat:@"GetNews?pageIndex=%d&pageSize=%d",pageIndex,pageSize];
        urlString = URL_Head(urlString);
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSLog(@"responseObject");
            tableArray = [[NSMutableArray alloc] initWithArray:responseObject];
            for (NSDictionary* dic in tableArray) {
                MainCellDish* model = [[MainCellDish alloc] initWithDic:dic];
                [DishArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self infinitRefreshEnd];
            });
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self infinitRefreshEnd];
            });
        }];
    }];
    
   // [_table triggerPullToRefresh];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  DishArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
    MyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    [cell setWithModel:DishArray[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这里值得改进一下。
    
    MainCellDish* dish = DishArray[indexPath.row];
    return  [ThridClass heightForString:[dish title] fontSize:18 andWidth:SCREENWIDTH-40]+30;
    
    
    
    
//    NSString* string = dish.title;
//    if(string.length>18)
//    {
//        return 105;
//    }else{
//        return 80;
//    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转，传值
    flag = indexPath.row;
    [self performSegueWithIdentifier:@"Content" sender:nil];
    
//    self.performSegueWithIdentifier("showAgeTableView", sender: nil)
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Content"]) {
       
        ContentViewController* content = (ContentViewController*)segue.destinationViewController;
        MainCellDish* dish = DishArray[flag];
        content.id_url = dish.ID;
      
    }
    

}

@end
