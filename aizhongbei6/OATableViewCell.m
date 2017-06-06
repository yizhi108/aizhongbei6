//
//  OATableViewCell.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/30.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "OATableViewCell.h"
#import "ThridClass.h"

@implementation OATableViewCell
{
    __weak IBOutlet UILabel *time;
    
    UILabel *title;
}


-(void)setWithModel:(OADish *)model
{
    
    title.numberOfLines = 0;
    
    title.text = [model title];
    NSString* content = [model title];
    CGFloat height = [ThridClass heightForString:content fontSize:17 andWidth:378];
//    CGRect rect = title.frame;
//    rect.size.height = height;
//    NSLog(@"%@",NSStringFromCGRect(title.frame));
//    title.frame = rect;
//    title.backgroundColor = [UIColor yellowColor];
//    NSLog(@"%@",NSStringFromCGRect(title.frame));
    [title setFrame:CGRectMake(20, 5, 378, height)];
    
    time.text = [model time];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    title = [[UILabel alloc] init];
    [self addSubview:title];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
