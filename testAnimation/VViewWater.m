//
//  VViewWater.m
//  testAnimation
//
//  Created by 汤维炜 on 16/3/17.
//  Copyright © 2016年 Tommy. All rights reserved.
//

#import "VViewWater.h"

@interface VViewWater ()
{
    UIColor *_currentWaterColor;
    float _currentLinePointY;
    
    float a;
    float b;
    
    BOOL jia;
}

@end

@implementation VViewWater

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        a = 1.5;
        b = 0;
        jia = NO;

        _currentWaterColor = [UIColor orangeColor];
        _currentLinePointY = frame.size.height / 5 * 3;
    }
    return self;
}

- (void)startAnimation {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(startWater) userInfo:nil repeats:YES];
}

- (void)startWater {
    if (jia) {
        a += 0.01;
    }else {
        a -= 0.01;
    }
    
    if (a<=1) {
        jia = YES;
    }else {
        jia = NO;
    }
    
    b += 0.1;
    
    [self setNeedsDisplay];
}

- (void)stopAnimation {
    [_timer invalidate];
    _timer = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    float y = _currentLinePointY;
    CGPathMoveToPoint(path, NULL, 0, y);
    
    for (float x =0; x<=320; x++) {
        y = a * sin(x/180*M_PI + 4*b/M_PI)*5 + _currentLinePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, 320,rect.size.height);
    CGPathAddLineToPoint(path, nil, 0,rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);

}


@end
