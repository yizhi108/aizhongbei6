//
//  SpaceViewController.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/26.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "SpaceViewController.h"
#import "HttpSection.h"
#import <SVProgressHUD.h>
#import <SVPullToRefresh.h>
#import "SpaceCellDish.h"
#import "SpeaceTableViewCell.h"
#import "ThridClass.h"

@interface SpaceViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    NSString* token;
    NSInteger pageIndex;
    NSInteger pageSize;
    NSInteger remarksPageIndex;
    NSInteger remarksPageSize;
    NSMutableArray* array;
    NSMutableArray* lengthArray;// 存放每个Cell中WebView 的高度。
    UIWebView* _webView;
    NSInteger flag;
    UIView* Takeview;
    UITextView* textView;
    NSMutableArray* RemarksArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation SpaceViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
   // self.tabBarController.selectedIndex = 1;
   // return;
    self.navigationController.navigationBar.topItem.title = @"空间";
    
    
    
     
    
    token = [USERDEFA objectForKey:TOKEN];
    if(token != nil && ![token isEqualToString:@""])
    {
        
        [self TalbeInit];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未登录" message:@"不能访问，请您登陆" preferredStyle:UIAlertControllerStyleAlert];
        
        //     [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.tabBarController.selectedIndex = 3;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)TalbeInit
{
    
    pageIndex = 1;
    pageSize = 5;
    remarksPageSize = INT_MAX;
    remarksPageIndex = 1;
    
    [_table registerNib:[UINib nibWithNibName:@"SpeaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [_table addPullToRefreshWithActionHandler:^{
       
        
        pageIndex = 1;
        NSString* string = [NSString stringWithFormat:@"GetTalkings?pageIndex=%ld&pageSize=%ld&remarksPageIndex=%ld&remarksPageSize=%ld",pageIndex,pageSize,remarksPageIndex,remarksPageSize];
        
        [HttpSection url:string type:@"GET" body:nil block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            array = [[NSMutableArray alloc] init];
            lengthArray = [[NSMutableArray alloc] init];
            NSString* string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
          //  NSLog(@"%@",string);
            NSData* data2 = [string dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableLeaves error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //
                for (NSDictionary* dic in jsonArray) {
                    SpaceCellDish* model = [[SpaceCellDish alloc] initWithDic:dic];
                    [array addObject:model];
                    [RemarksArray addObject:[model Remarks]];
                }
                //
                
                flag = 0;
                [self LengthArrayAction:array[flag]];
               //
            });
            
            
        }];
    }];
    
    
    [_table addInfiniteScrollingWithActionHandler:^{
        pageIndex++;
        NSString* string = [NSString stringWithFormat:@"GetTalkings?pageIndex=%ld&pageSize=%ld&remarksPageIndex=%ld&remarksPageSize=%ld",pageIndex,pageSize,remarksPageIndex,remarksPageSize];
        [HttpSection url:string type:@"GET" body:nil block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString* string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         //   NSLog(@"%@",string);
            NSData* data2 = [string dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableLeaves error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                for (NSDictionary* dic in jsonArray) {
                    SpaceCellDish* model = [[SpaceCellDish alloc] initWithDic:dic];
                    [array addObject:model];
                }
                flag ++;
                [self LengthArrayAction:array[flag]];
            });

            
        }];
    }];
    
    
    [_table triggerPullToRefresh];
}

-(void)LengthArrayAction:(SpaceCellDish*)model
{
    _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 0)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.scrollEnabled = NO;
    [_webView sizeToFit];
    
    ///////////////////////////////设置内容，这里包装一层div，用来获取内容实际高度（像素），htmlcontent是html格式的字符串//////////////
    NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", [model Contents]];
    [_webView loadHTMLString:htmlcontent baseURL:nil];

}

// web加载完成调用。
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.clientHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').clientHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    CGFloat height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
   // NSLog(@"%f",height);
    [lengthArray addObject:@(height)];
    if(flag != array.count-1)
    {
        flag ++;
        [self LengthArrayAction:array[flag]];
        
    }else
    {
        if(flag == 4)
        {
            [self refreshShouldEnd];

        }else{
            [self infinitRefreshEnd];
        }
        
    }
    //webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    
}




- (void)refreshShouldEnd
{
    
    [_table reloadData];
    [_table.pullToRefreshView stopAnimating];
}

-(void)infinitRefreshEnd
{
    [_table reloadData];
    [_table.infiniteScrollingView stopAnimating];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    SpeaceTableViewCell* cell = [[SpeaceTableViewCell alloc] init];
    //SpeaceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"]; //webView 加载不够快，这种方法不行。
    // MyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    [cell setWithModel:array[indexPath.row] webHeight:[lengthArray[indexPath.row] floatValue] Controller:self];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [lengthArray[indexPath.row] floatValue];//这个高度，仅仅是，webView的高度。
    //
    NSArray* array1 = [[NSArray alloc]initWithArray:[array[indexPath.row] Remarks]];
    CGFloat sum = 80;// 原先是60
    for(long  i = array1.count;i>0;i--)
    {
        UILabel* label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        NSDictionary* dic = array1[i-1];
        NSString* content = [NSString stringWithFormat:@"%@%@%@",[dic valueForKey:@"NiCheng"],[dic valueForKey:@"RemarkTime"],[dic valueForKey:@"Remarks"]];
        label.font = [UIFont systemFontOfSize:17];
        
        CGFloat height = [ThridClass heightForString:content fontSize:17 andWidth:SCREENWIDTH-20];
        
        sum += height+1.9;
    }
    return height+sum;
}


-(void)addTake:(id)sender
{
    NSInteger i = [sender tag];
    
    Takeview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    Takeview.backgroundColor = [UIColor clearColor];
    UIView* view = [[UIView alloc ] initWithFrame:CGRectMake(20, 200, SCREENWIDTH-40, SCREENWIDTH/3+130)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.shadowOpacity = 0.5;// 阴影透明度
    view.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    view.layer.shadowRadius = 3;// 阴影扩散的范围控制
    view.layer.shadowOffset  = CGSizeMake(1, 1);
    
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(35,220, SCREENWIDTH-80, SCREENWIDTH/3+60)];
    textView.text = @"请输入评论";

    [textView setFont:[UIFont systemFontOfSize:20]];
    
    
    
    UIButton* cancel = [[UIButton alloc] initWithFrame:CGRectMake(40, 280+SCREENWIDTH/3, 100, 50)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton* confirm = [[UIButton alloc] initWithFrame:CGRectMake(240, 280+SCREENWIDTH/3, 100, 50)];
    
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirm setTag:i];
    
    [Takeview addSubview:view];
    [Takeview addSubview:confirm];
    [Takeview addSubview:cancel];
    [Takeview addSubview:textView];
    
    [self.view addSubview:Takeview];
    
    
}

-(void)confirmAction:(id)sender
{
    NSInteger talkingID = [sender tag];
    NSString *content = textView.text;
    NSString* body = [NSString stringWithFormat:@"talkingID=%ld&remarks=%@",talkingID,content];
    [HttpSection url:@"AddTalkingRemark" type:@"POST" body:body block:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      //  NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",dataString);
//        NSLog(@"%@",response);
//        NSLog(@"%@",error);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Takeview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [Takeview removeFromSuperview];
            Takeview.hidden = YES;
            [_table triggerPullToRefresh];
           
        });
    }];
    
    
}

-(void)cancelAction
{
    [Takeview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [Takeview removeFromSuperview];
   // _table.editing = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
