//
//  MyTableViewCell.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/25.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "MyTableViewCell.h"
#import "ThridClass.h"

@implementation MyTableViewCell
{
    
    __weak IBOutlet UITextView *check;
    __weak IBOutlet UITextView *time;
    UILabel *title;
}

-(void)setWithModel:(MainCellDish *)model
{
    [title setFrame:CGRectMake(20, 0, SCREENWIDTH-40, 10)];
    time.text =[NSString stringWithFormat:@"%@",model.PublishTime];
    title.numberOfLines = 0;
//    title.backgroundColor = [UIColor redColor];
    title.text = model.title;
    float height = [ThridClass heightForString: model.title fontSize:18 andWidth:SCREENWIDTH-40];
    
    CGRect rect = title.frame;
    rect.size.height = height;
    
    title.frame = rect;
    
    check.text = [NSString stringWithFormat:@"%ld",model.Hits];
    
    
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
