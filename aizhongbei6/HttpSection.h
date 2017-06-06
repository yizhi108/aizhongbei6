//
//  HttpSection.h
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/26.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpSection : NSObject

+(void)url:(NSString*_Nullable)url type:(NSString* _Nullable)type body:(NSString*_Nullable)body block:(void(^_Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))block;
+(void)urlPic:(NSString*_Nullable)url type:(NSString* _Nullable)type body:(NSString*_Nullable)body block:(void(^_Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))block;
@end
