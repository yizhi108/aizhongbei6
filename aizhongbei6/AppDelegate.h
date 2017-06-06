//
//  AppDelegate.h
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/23.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

