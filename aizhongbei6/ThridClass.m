//
//  ThridClass.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/26.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "ThridClass.h"

@implementation ThridClass

+(void)SVProgressHUD_dismiss
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+(BOOL)imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+(NSString*)imageBase64:(UIImage*)image
{
    NSData *imageData = nil;
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        
    } else {
        imageData = UIImageJPEGRepresentation(image, 0.3f);
        
    }
    
    //   NSString* Datastring = [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:0]];
    NSString *Datastring2 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return Datastring2;
}

+(NSString *)imageEnd:(NSString *)str
{
    str = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
   // NSLog(@"%@",str);
    return str;
}

//UIlabel 高度
+(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

+(NSString*)time:(NSString*)originalString
{
    
    NSString* PublishString1 = [originalString componentsSeparatedByString:@"T"][0];
    NSString *month = [PublishString1 componentsSeparatedByString:@"-"][1];
    NSString *day = [PublishString1 componentsSeparatedByString:@"-"][2];
    NSString* PublishString2 = [originalString componentsSeparatedByString:@"T"][1];
    NSString* hour =[PublishString2 componentsSeparatedByString:@":"][0];
    NSString* sends =[PublishString2 componentsSeparatedByString:@":"][1];
    //  NSLog(@"%@  %@",month,day);
    
    NSString *time = [NSString stringWithFormat:@"%@-%@ %@:%@",month,day,hour,sends];
    return time;
    
}

+ (BOOL) isMobile:(NSString*)mobileNumbel{
    
    NSString *MOBILE =@"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    
    NSPredicate  *regextestmobile = [NSPredicate   predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return  [regextestmobile  evaluateWithObject:mobileNumbel];
    
}

@end
