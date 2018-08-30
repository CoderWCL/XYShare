//
//  XYShareImage.h
//  mimapi
//
//  Created by 吕万昌 on 2018/8/29.
//  Copyright © 2018年 lvwanchang. All rights reserved.
//

#import "XYShareBaseObject.h"

@interface XYShareImage : XYShareBaseObject

/** 分享单个图片（支持UIImage，NSdata以及图片链接Url NSString类对象集合）
 * @note 图片大小根据各个平台限制而定
 */
@property (nonatomic, retain) id shareImage;

@end
