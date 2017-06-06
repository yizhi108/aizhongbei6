//
//  SpaceCellDish.h
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/27.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpaceCellDish : NSObject

@property(nonatomic,copy)NSString* picString;
@property(nonatomic,copy)NSString* nameString;
@property(nonatomic,copy)NSString* Contents;
@property(nonatomic,retain)NSArray* picArray;
@property(nonatomic,retain)NSArray* Remarks;
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,copy)NSString* PublishTime;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
