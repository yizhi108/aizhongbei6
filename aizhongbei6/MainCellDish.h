//
//  MainCellDish.h
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/25.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainCellDish : NSObject

@property (nonatomic,assign)NSInteger Hits;
@property (nonatomic,copy)NSString* PublishTime;
@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,copy)NSString* title;
@property (nonatomic,copy)NSString* TitlePicture;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
