//
//  OADish.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/30.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "OADish.h"
#import "ThridClass.h"

@implementation OADish

-(instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        self.ID = [dic valueForKey:@"ID"];
//        self.time = [dic valueForKey:@"Time"];
        self.time = [ThridClass time:[dic valueForKey:@"Time"]];
        self.title = [dic valueForKey:@"Title"];
        
    }
    return  self;
}

@end

