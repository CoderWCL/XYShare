//
//  UIViewController+XYShare.m
//  mimapi
//
//  Created by 吕万昌 on 2018/8/29.
//  Copyright © 2018年 lvwanchang. All rights reserved.
//

#import "UIViewController+XYShare.h"

#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

#import <objc/runtime.h> //包含对类、成员变量、属性、方法的操作
#import <objc/message.h> //包含消息机制

//弱引用
#define WEAKSELF  __weak typeof(self) weakSelf = self;
//强引用
#define STRONGSELF  __strong typeof(weakSelf) strongSelf = weakSelf;

static const int block_key;

@interface UIViewController()<UMSocialShareMenuViewDelegate>

@end

@implementation UIViewController (XYShare)

/**
 分享接口
 @param menuViewStatus 分享面板状态block
 @param clickComplete 点击平台回调block (XYShareBaseObject 分享的对象模型)
 @param complete 分享结果回调
 */
- (void)showShareWithShareMenuViewStatus:(void(^)(int status))menuViewStatus
                           clickPlatform:(XYShareBaseObject *(^)(void))clickComplete
                                complete:(void(^)(NSError *error))complete {
    
    //为menuViewStatus 赋值
    objc_setAssociatedObject(self, &block_key, menuViewStatus, OBJC_ASSOCIATION_COPY_NONATOMIC);
    //分享面板状态代理
    [UMSocialUIManager setShareMenuViewDelegate:self];
    
    //定制平台面板
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    WEAKSELF
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        STRONGSELF
        if (clickComplete) {
            id shareObject = clickComplete();
            [strongSelf showUMShareWithShareObject:shareObject platformType:platformType complete:^(NSError *error) {
                if (complete) {
                    complete(error);
                }
            }];
            
        }
    }];
}

/**
 友盟分享接口
 
 @param platformType 分享平台
 @param shareObject 分享对象模型
 @param complete 分享结果回调
 */
- (void)showUMShareWithShareObject:(XYShareBaseObject *)shareObject
                      platformType:(UMSocialPlatformType)platformType
                          complete:(void(^)(NSError *error))complete {
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.title = shareObject.title;
    messageObject.text = shareObject.content;
    
    UMShareObject *umShareObject = nil;
    if ([shareObject isKindOfClass:[XYShareText class]]) {
        
    } else if ([shareObject isKindOfClass:[XYShareImage class]]) {
        XYShareImage *shareImage = (XYShareImage *)shareObject;
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        //shareObject.thumbImage = [UIImage imageNamed:@"icon"];
        [shareObject setShareImage:shareImage.shareImage];
        
        umShareObject = shareObject;

    } else if ([shareObject isKindOfClass:[XYShareWebLink class]]) {
        
    }

    //分享消息对象设置分享内容对象
    messageObject.shareObject = umShareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (complete) {
            complete(error);
        }
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        } else {
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            } else {
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

#pragma mark - UMSocialShareMenuViewDelegate

/**
 *  分享面板显示的回调
 */
- (void)UMSocialShareMenuViewDidAppear {
    
    void (^block)(int type) = objc_getAssociatedObject(self, &block_key);
    
    if (block) {
        block(XYShareMenuStatusDidAppear);
    }

}

/**
 *  分享面板的消失的回调
 */
- (void)UMSocialShareMenuViewDidDisappear {
    void (^block)(int type) = objc_getAssociatedObject(self, &block_key);
    
    if (block) {
        block(XYShareMenuStatusDisappear);
    }
}

///**
// *  返回分享面板的父窗口,用于嵌入在父窗口上显示
// *
// *  @param defaultSuperView 默认加载的父窗口
// *
// *  @return 返回实际的父窗口
// *  @note 返回的view应该是全屏的view，方便分享面板来布局。
// *  @note 如果用户要替换成自己的ParentView，需要保证该view能覆盖到navigationbar和statusbar
// *  @note 当前分享面板已经是在window上,如果需要切换就重写此协议，如果不需要改变父窗口则不需要重写此协议
// */
//- (UIView*)UMSocialParentView:(UIView*)defaultSuperView {
//

//}

@end
