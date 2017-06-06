//
//  HttpSection.m
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/26.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import "HttpSection.h"

#define boundary @"AaB03x"

@implementation HttpSection

+(void)url:(NSString*_Nullable)url type:(NSString* _Nullable)type body:(NSString*_Nullable)body block:(void(^_Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))block
{
    NSURLSession* session = [NSURLSession sharedSession];
//    NSString* urlString =;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: URL_Head(url)]];
    [request setHTTPMethod:type];
    if([body length]!=0)
    {
        // 表示疑问
        
        
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        [request  setHTTPBody:data];
        
    }
    NSString *token = [USERDEFA objectForKey:TOKEN];
    
    NSString* token2 = [@"bearer "stringByAppendingString:token];
  //  NSLog(@"%@",body);
   // NSLog(@"%@",token2);
    
    // NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8;boundary=%@", boundary];
   //  [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    //[request addValue:token2 forHTTPHeaderField:@"Authorization"];
    [request setValue:token2 forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if(block){
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:block];
        
        [task resume];
    }

    
}

+(void)urlPic:(NSString*_Nullable)url type:(NSString* _Nullable)type body:(NSString*_Nullable)body block:(void(^_Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))block
{
    NSURLSession* session = [NSURLSession sharedSession];
    //    NSString* urlString =;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: URL_Head(url)]];
    [request setHTTPMethod:type];
    if([body length]!=0)
    {
        // 表示疑问
        /*NSString *baseStr = [imgData base64Encoding];
         NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
         (CFStringRef)baseStr,
         NULL,
         CFSTR(":/?#[]@!$&’()*+,;="),
         kCFStringEncodingUTF8);
         [urlRequest setHTTPBody:[baseString dataUsingEncoding:NSUTF8StringEncoding]];  */
        //NSString* baseString = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)body, nil, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
        NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
        [request  setHTTPBody:data];
        
    }
    NSString *token = [USERDEFA objectForKey:TOKEN];
    
    NSString* token2 = [@"bearer "stringByAppendingString:token];
   // NSLog(@"%@",body);
   // NSLog(@"%@",token2);
    
    // NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8;boundary=%@", boundary];
    //  [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    //[request addValue:token2 forHTTPHeaderField:@"Authorization"];
    [request setValue:token2 forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if(block){
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:block];
        
        [task resume];
    }
    
    
}



@end
