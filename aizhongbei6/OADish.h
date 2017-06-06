//
//  OADish.h
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/30.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OADish : NSObject

@property(nonatomic,copy)NSString* ID;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* time;

-(instancetype)initWithDic:(NSDictionary*)dic;

@end
