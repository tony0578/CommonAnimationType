//
//  VViewWater.h
//  testAnimation
//
//  Created by 汤维炜 on 16/3/17.
//  Copyright © 2016年 Tommy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VViewWater : UIView

- (void)startAnimation;
- (void)stopAnimation;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIColor *waterColor;

@end
