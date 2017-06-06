//
//  SpeaceTableViewCell.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/27.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "SpeaceTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "ThridClass.h"

@implementation SpeaceTableViewCell
{
    UIWebView *webView;
    UIImageView *imageView;
    UILabel *nameLable;
    UILabel *PublishTimeLabel;
    
}

-(void)setWithModel:(SpaceCellDish *)model webHeight:(CGFloat)webHegiht Controller:(SpaceViewController*)controller
{
    NSLog(@"%f",self.frame.size.width);
   // [self setBackgroundColor:[UIColor redColor]];
    webView = [[UIWebView alloc] init];
    imageView = [[UIImageView alloc] init];
    nameLable = [[UILabel alloc] init];
    PublishTimeLabel = [[UILabel alloc] init];
    imageView.frame = CGRectMake(5, 5, 50, 50);
    nameLable.frame = CGRectMake(60, 15, 200, 20);
    PublishTimeLabel.frame = CGRectMake(280, 15, 200, 20);
    webView.frame = CGRectMake(10, 60, SCREENWIDTH-20, webHegiht);
    
    
    [self addSubview:webView];
    [self addSubview:imageView];
    [self addSubview:nameLable];
    [self addSubview:PublishTimeLabel];
    
    nameLable.text = [model nameString];
    PublishTimeLabel.text = [model PublishTime];
    
    [imageView sd_setImageWithURL:[model picString] placeholderImage:[UIImage imageNamed:@"12.jpg"]];
    //[imageView setImage:[UIImage imageNamed:@"12.jpg"]];
    
    [webView loadHTMLString:[model Contents]baseURL:nil];
    webView.userInteractionEnabled = NO;
//    [webView setBackgroundColor:[UIColor redColor]];
    NSLog(@"%@",[model Contents]);
    NSArray* array = [[NSArray alloc]initWithArray:[model Remarks]];
    CGFloat sum = 60;
    for(long  i = array.count;i>0;i--)
    {
        NSDictionary* dic = array[i-1];
        UIImageView* image = [[UIImageView alloc] init];
        [image sd_setImageWithURL:[dic valueForKey:@"UserPicture"] placeholderImage:[UIImage imageNamed:@"face.png"]];
        image.frame = CGRectMake(5, webHegiht+sum, 20, 20);
        
        [self addSubview:image];
        
        
        
        
        UILabel* label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        
        NSString* content = [NSString stringWithFormat:@"%@ %@ %@",[dic valueForKey:@"NiCheng"],[ThridClass time:[dic valueForKey:@"RemarkTime"]],[dic valueForKey:@"Remarks"]];
        //
        label.font = [UIFont systemFontOfSize:17];
        
        CGFloat height = [SpeaceTableViewCell heightForString:content fontSize:17 andWidth:SCREENWIDTH-20];
        
        [label setFrame:CGRectMake(30, webHegiht+sum, SCREENWIDTH-20, height)];
        sum += height+2;
        label.text = content;
       // label.backgroundColor = [UIColor yellowColor];
        [self addSubview:label];
    }
   
    // 添加评论
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH-50, sum+webHegiht, 20, 20)];
    //button.backgroundColor = [UIColor grayColor];
    [button setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    [button addTarget:controller action:@selector(addTake:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:model.ID];
    
    
    [self addSubview:button];
    /*
     "Remarks": "1231546481318464618165148443481314445181",
     "Username": "13527261459",
     "NiCheng": "yizhi",
     "UserPicture": "http://59.48.248.41:1020//Content/Images/boy.jpg",
     "RemarkTime": "2017-05-25T17:34:05.733"
     */
}




+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
