//
//  ThridClass.h
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/26.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD.h>

@interface ThridClass : NSObject

+(void)SVProgressHUD_dismiss;
+(NSString*)imageBase64:(UIImage*)image;
+(BOOL)imageHasAlpha: (UIImage *) image;
+(NSString*)imageEnd:(NSString*)str;
+(float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
+(NSString*)time:(NSString*)originalString;
+ (BOOL) isMobile:(NSString*)mobileNumbel;
@end
