//
//  CustomButton.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/24.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton



@end

@implementation CustomButton

-(instancetype)initWithFrame:(CGRect)frame titleString:(NSString*)titleString subString:(NSString*)subString imageName:(NSString*)imageName
{
    if((self=[super initWithFrame:frame])==nil) return nil;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 25, 50, 50)];
    
    [imageView setImage:[UIImage imageNamed:imageName]];
    
    [self addSubview:imageView];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(85, 25, 100, 25)];
    title.text = titleString;
   // title.editable = NO;
    title.font = [UIFont boldSystemFontOfSize:15];
    
    [self addSubview:title];
    
    UILabel* sub = [[UILabel alloc] initWithFrame:CGRectMake(85, 50, 150, 20)];
    sub.text = subString;
   // sub.editable =  NO;
    sub.textColor = [UIColor grayColor];
    [self addSubview:sub];
    
   // [self.layer setBorderWidth:1.0];
   // CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
   // [self.layer setBorderColor:colorref];
    
    return self;
    
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    
}


@end
