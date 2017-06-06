//
//  MainCellDish.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/25.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "MainCellDish.h"
#import "ThridClass.h"

@implementation MainCellDish

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
//        NSLog(@"%@",dic);
        //        self.title = dic[@"Title"];
        self.title = [NSString stringWithString:dic[@"Title"]];
     //   NSLog(@"%@",self.title);
        self.ID = [dic[@"ID"] integerValue];
        self.Hits = [dic[@"Hits"] integerValue];
        self.TitlePicture = [[NSString alloc] initWithFormat:@"%@",dic[@"TitlePicture"]];
       NSString* PublishString = [NSString stringWithString:dic[@"PublishTime"]];
        
        self.PublishTime = [ThridClass time:PublishString];
        
    }
    return self;
}

@end
