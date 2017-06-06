//
//  SpaceCellDish.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/27.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "SpaceCellDish.h"
#import "ThridClass.h"

@implementation SpaceCellDish

- (instancetype)initWithDic:(NSDictionary*)dic
{
    NSLog(@"%@",dic);
    _nameString = [NSString stringWithString:[dic valueForKey:@"Nickname"]];
    _picString = [dic valueForKey:@"UserPictureUrl"];
    _Remarks = [[NSArray alloc] initWithArray:[dic valueForKey:@"Remarks"]];
    _Contents = [dic valueForKey:@"Contents"];
    _ID = [[dic valueForKey:@"ID"] intValue];
    _PublishTime = [ThridClass time:[dic valueForKey:@"PublishTime"]];
    
    
    return self;
}

@end
