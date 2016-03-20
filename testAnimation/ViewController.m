//
//  ViewController.m
//  testAnimation
//
//  Created by Tommy on 16/3/17.
//  Copyright © 2016年 Tommy. All rights reserved.
//

#import "ViewController.h"
#import "VViewWater.h"
#import "UIView+Extension.h"

typedef NS_ENUM (NSInteger, animateType) {
    waterAnimateType,
    buddleAnimateType,
    cycleAnimateType,
};

#define viewwidth                     self.view.frame.size.width
#define viewheight                    self.view.frame.size.height
#define buttonWidth                   ((int)(viewwidth/3))

#define IMAGE_WIDTH                   arc4random()%50 + 10
#define IMAGE_X                       arc4random()%200
#define IMAGE_ALPHA                   ((float)(arc4random()%10))/10

@interface ViewController ()<UIScrollViewDelegate>
{
    NSTimer      *_cycleTimer;
    NSTimer      *_buddleTimer;
    UIImageView  *_cycleImageview;
    BOOL         _isCloseBuddleTimer;
    BOOL         _isStopCycleAnimation;
    float        _angle;

}

@property (nonatomic, strong) VViewWater     *water;

@property (nonatomic, strong) UIButton       *waterButton;
@property (nonatomic, strong) UIButton       *buddleButton;
@property (nonatomic, strong) UIButton       *cycleButton;

@property (nonatomic, strong) UIView         *buddleBgview;
@property (nonatomic, strong) UIView         *waterBgview;
@property (nonatomic, strong) UIView         *cycleBgview;

@property (nonatomic, strong) UIScrollView   *scrollview;
@property (nonatomic, strong) UIView         *modelView;
@property (nonatomic, assign) animateType    type;

@property (nonatomic, strong) NSMutableArray *imagesArr;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mainUI];

    [self addButtonUI];

}

#pragma mark - UI

- (void)mainUI {
    
    _scrollview  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewwidth, viewheight-68)];
    _scrollview.backgroundColor = [UIColor grayColor];
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator   = NO;
    _scrollview.delegate = self;
    _scrollview.pagingEnabled = YES;
    [self.view addSubview:_scrollview];
    
    CGSize size = _scrollview.frame.size;
    size.width  *= 3;
    _scrollview.contentSize = size;
}

// 波浪UI

- (void)drawWaterAnimateTypeUI {
    
    _waterBgview = [self drawBgviewWithCGRect:CGRectMake(0, 0, 300, 300) bgColor:[UIColor orangeColor] centerPoint:self.view.center];
    _water       = [[VViewWater alloc]initWithFrame:CGRectMake(0, 0, _waterBgview.frame.size.width, _waterBgview.frame.size.height)];
    [_waterBgview addSubview:_water];
}

// 冒泡UI

- (void)drawBuddleAnimateTypeUI {
    
    _buddleBgview = [self drawBgviewWithCGRect:CGRectMake(viewwidth, 0, 300, 300) bgColor:[UIColor orangeColor] centerPoint:CGPointMake(viewwidth/2+viewwidth, viewheight/2)];
    
    _imagesArr    = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<15; i++) {

        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble@2x"]];
        float x                = IMAGE_WIDTH;
        imageview.frame        = CGRectMake(IMAGE_X, _buddleBgview.frame.size.height + 10, x, x);
        imageview.alpha        = IMAGE_ALPHA;
        [_buddleBgview addSubview:imageview];
        [_imagesArr addObject:imageview];
    }
    
    if (!_isCloseBuddleTimer) {
        
        _buddleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addBuddle) userInfo:nil repeats:YES];
        [_buddleTimer fire];
    }
    
}

// 转圈UI

- (void)drawCycleAnimateTypeUI {
    
    _cycleBgview          = [self drawBgviewWithCGRect:CGRectMake(2*viewwidth, 0, 300, 300) bgColor:[UIColor clearColor] centerPoint:CGPointMake(viewwidth/2+2*viewwidth, viewheight/2)];
    
    _cycleImageview       = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cycle"]];
    _cycleImageview.frame = CGRectMake(0, 0, 300, 300);
    [_cycleBgview addSubview:_cycleImageview];

    _cycleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCycleAnimation) userInfo:nil repeats:YES];
    [_cycleTimer fire];
    
}

- (void)startCycleAnimation {

    if (_angle <= 0) {
        [self cycleAnimation];
    }
}

- (UIView *)drawBgviewWithCGRect:(CGRect)rect
                         bgColor:(UIColor *)color
                     centerPoint:(CGPoint)center {
    
    UIView *view =[[UIView alloc]initWithFrame:rect];
    [view roundedViewWithRadius:150 borderWidth:2 borderColor:[color CGColor]];
    view.center = center;
    [_scrollview addSubview:view];
    
    return view;
}

- (void)addBuddle {
    
    _isCloseBuddleTimer = YES;
    if (_imagesArr.count >0) {
        UIImageView *imageview = [_imagesArr objectAtIndex:0];
        
        [UIView animateWithDuration:0.6 animations:^{
            imageview.frame = CGRectMake(imageview.frame.origin.x, -20, imageview.frame.size.width, imageview.frame.size.height);
            
        } completion:^(BOOL finished) {
            [imageview removeFromSuperview];
            [_imagesArr removeAllObjects];
            [_buddleBgview removeFromSuperview];
            [self drawBuddleAnimateTypeUI];
        }];
    }
}

/**
 *  把要执行的动画放在 [UIView beginAnimation.....] 和 [UIView commitAnimations] 之间；
 */

- (void)cycleAnimation {
    if (_isStopCycleAnimation) {
        return;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.02];
    [UIView setAnimationDelegate:self];
    CATransform3D transform = CATransform3DMakeRotation(_angle*(M_PI/180.f), 0, 0, 1);
    _cycleImageview.layer.transform = transform;
    [UIView setAnimationDidStopSelector:@selector(finishedRotationAnimation)];
    [UIView commitAnimations];

}

- (void)rotationAnimation
{
    CATransform3D transform = CATransform3DMakeRotation(_angle*(M_PI/180.f), 0, 0, 1);
    _cycleImageview.layer.transform = transform;

}

- (void)finishedRotationAnimation {
    _angle += 3;
    [self cycleAnimation];
}

- (void)addButtonUI {
  
    _waterButton  = [self addButtonWithTitle:@"开始波浪" horizenX:0 selectedTag:1 select:@selector(startWater:)];
    _buddleButton = [self addButtonWithTitle:@"开始冒泡" horizenX:buttonWidth selectedTag:2 select:@selector(addBuddle:)];
    _cycleButton  = [self addButtonWithTitle:@"开始转圈" horizenX:buttonWidth*2 selectedTag:3 select:@selector(startCycle:)];

    [self.view addSubview:_waterButton];
    [self.view addSubview:_buddleButton];
    [self.view addSubview:_cycleButton];
    
    _modelView = [[UIView alloc] init];
    _modelView.frame = CGRectMake(0, viewheight-2, buttonWidth, 2);
    _modelView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_modelView];
}


#pragma mark - UIScrollviewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = _scrollview.contentOffset;
    CGFloat x      = offset.x/3;

    if (x>0 && x<scrollView.frame.size.width) {
        
        CGRect frame     = self.modelView.frame;
        frame.origin.x   = x;
        _modelView.frame = frame;
    }
}

- (UIButton *)addButtonWithTitle:(NSString *)title horizenX:(int)horizenX selectedTag:(int)tag select:(SEL)selector{
    
    UIButton *btn       = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag             = tag;
    btn.frame           = CGRectMake(horizenX, viewheight-50, buttonWidth, 46);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];

    return btn;
}


#pragma mark - Action

- (void)addAnimationUIWithType:(int)type {
    
    switch (type) {
        case waterAnimateType:
            [self drawWaterAnimateTypeUI];
            break;
        case buddleAnimateType:
            [self drawBuddleAnimateTypeUI];
            break;
        case cycleAnimateType:
            [self drawCycleAnimateTypeUI];
            break;
            
        default:
            break;
    }
}

// 动画波浪

- (void)startWater:(UIButton *)sender {
    if ([_waterButton.titleLabel.text isEqualToString:@"开始波浪"]){
        [self addAnimationUIWithType:waterAnimateType];
        [_water startAnimation];
        [_waterButton setTitle:@"关闭波浪" forState:UIControlStateNormal];
    }else{
        [_water stopAnimation];
        [_waterButton setTitle:@"开始波浪" forState:UIControlStateNormal];
        [_waterBgview removeFromSuperview];
    }
    [_scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

// 动画冒泡

- (void)addBuddle:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"开始冒泡"]){
        [self addAnimationUIWithType:buddleAnimateType];
        [sender setTitle:@"关闭冒泡" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"开始冒泡" forState:UIControlStateNormal];
        [_buddleBgview removeFromSuperview];
        [_buddleTimer invalidate];
        _buddleTimer = nil;
    }
    [_scrollview setContentOffset:CGPointMake(viewwidth, 0) animated:YES];
}

// 动画转圈

- (void)startCycle:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"开始转圈"]){
        _angle = 0;
        _isStopCycleAnimation = NO;
        [self addAnimationUIWithType:cycleAnimateType];
        [sender setTitle:@"关闭转圈" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"开始转圈" forState:UIControlStateNormal];
        [_cycleBgview removeFromSuperview];
        [_cycleTimer invalidate];
        _cycleTimer = nil;
        _isStopCycleAnimation = YES;
    }

    [_scrollview setContentOffset:CGPointMake(2*viewwidth, 0) animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
