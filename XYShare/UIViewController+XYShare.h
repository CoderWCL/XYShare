//
//  UIViewController+XYShare.h
//  mimapi
//
//  Created by 吕万昌 on 2018/8/29.
//  Copyright © 2018年 lvwanchang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XYShareBaseObject.h"
#import "XYShareText.h"
#import "XYShareImage.h"
#import "XYShareWebLink.h"

typedef enum : NSUInteger {
    XYSharedPlatformTypeQQ,
    XYSharedPlatformTypeWechatSession,
    XYSharedPlatformTypeWechatTimeLine,
    XYSharedPlatformTypeSina,
} XYSharedPlatformType; //分享平台

typedef enum : NSUInteger {
    XYShareMenuStatusDidAppear,     //分享面板出现
    XYShareMenuStatusDisappear,     //分享面板消失
    
} XYShareMenuStatus; //分享面板状态

@interface UIViewController (XYShare)

/**
 分享接口
 @param menuViewStatus 分享面板状态block
 @param clickComplete 点击平台回调block (XYShareBaseObject 分享的对象模型)
 @param complete 分享结果回调
 */
- (void)showShareWithShareMenuViewStatus:(void(^)(int status))menuViewStatus
                           clickPlatform:(XYShareBaseObject *(^)(XYSharedPlatformType platformType))clickComplete
                                complete:(void(^)(NSError *error))complete;
@end
