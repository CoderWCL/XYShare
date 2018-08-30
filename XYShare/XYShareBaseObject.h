//
//  XYShareBaseObject.h
//  mimapi
//
//  Created by 吕万昌 on 2018/8/29.
//  Copyright © 2018年 lvwanchang. All rights reserved.
//

#import "NSObject.h"

@interface XYShareBaseObject : NSObject

/**
 分享标题
 */
@property (nonatomic, copy) NSString *title;
/**
 分享内容
 */
@property (nonatomic, copy) NSString *content;

@end
