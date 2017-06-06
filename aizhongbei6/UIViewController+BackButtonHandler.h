//
//  UIViewController+BackButtonHandler.h
//  aizhongbei6
//
//  Created by zhangyao on 2017/5/31.
//  Copyright © 2017年 zhangyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackButtonHandler)<BackButtonHandlerProtocol>

@end
