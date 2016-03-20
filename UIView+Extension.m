//
//  UIView+Extension.m
//  testAnimation
//
//  Created by 汤维炜 on 16/3/18.
//  Copyright © 2016年 Tommy. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)roundedViewWithRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(CGColorRef)colorRef
{
    // 圆角设置
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    
    // 圆角边框颜色
    self.layer.borderWidth = width;
    self.layer.borderColor = colorRef;
}

- (void)changeFrameWithOriginX:(CGFloat)x originY:(CGFloat)y sizeWidth:(CGFloat)width sizeHeight:(CGFloat)height
{
    CGRect newFrame = self.frame;
    if (x != 0) newFrame.origin.x += x;    // 改变水平位置
    if (y != 0) newFrame.origin.y += y;    // 改变垂直位置
    if (width != 0) newFrame.size.width += width;      // 改变宽度
    if (height != 0) newFrame.size.height += height;   // 改变高度
    self.frame = newFrame;
}

@end
