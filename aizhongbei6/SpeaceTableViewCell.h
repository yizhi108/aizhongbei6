//
//  SpeaceTableViewCell.h
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/27.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpaceCellDish.h"
#import "SpaceViewController.h"

@interface SpeaceTableViewCell : UITableViewCell

-(void)setWithModel:(SpaceCellDish *)model webHeight:(CGFloat)webHegiht Controller:(SpaceViewController*)controller;



@end
