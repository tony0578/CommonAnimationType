//
//  UIView+Extension.h
//  testAnimation
//
//  Created by 汤维炜 on 16/3/18.
//  Copyright © 2016年 Tommy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
// 圆角视图
- (void)roundedViewWithRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(CGColorRef)colorRef;

// 重设视图的位置
- (void)changeFrameWithOriginX:(CGFloat)x originY:(CGFloat)y sizeWidth:(CGFloat)width sizeHeight:(CGFloat)height;

@end
