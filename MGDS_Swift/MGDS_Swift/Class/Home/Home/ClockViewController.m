//
//  ClockViewController.m
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

#import "ClockViewController.h"

#define angle2radio(angle) angle*M_PI/180
// 一秒钟秒钟转多少度
#define perSecAngle 6
// 一分钟分钟转多少度
#define perMinAngle 6
// 一个小时时钟转多少度
#define perHourAngle 30
// 一分钟时钟转多少度
#define perMinHourA 0.5


@interface ClockViewController ()
@property (nonatomic,weak) UIImageView *clockView;
/** 秒钟 */
@property (nonatomic,weak) CALayer *secLayer;
/** 分钟 */
@property (nonatomic,weak) CALayer *minLayer;
/** 时钟 */
@property (nonatomic,weak) CALayer *hourLayer;

@end

@implementation ClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"时钟";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *clockView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    clockView.center = self.view.center;
    clockView.image = [UIImage imageNamed:@"钟表"];
    [self.view addSubview:clockView];
    self.clockView = clockView;
    
    CALayer *secLayer = [[CALayer alloc] init];
    [self setLayer:secLayer WithHeight:80 withColor:[UIColor redColor]];
    _secLayer = secLayer;
    CALayer *minLayer = [[CALayer alloc] init];
    [self setLayer:minLayer WithHeight:70 withColor:[UIColor blackColor]];
    _minLayer = minLayer;
    CALayer *hourLayer = [[CALayer alloc] init];
    [self setLayer:hourLayer WithHeight:60 withColor:[UIColor darkGrayColor]];
    _hourLayer = hourLayer;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    [self timeChange];
    
}

- (void)setLayer:(CALayer *)layer WithHeight:(CGFloat)height withColor:(UIColor *)color {
    layer.backgroundColor = color.CGColor;
    layer.frame = CGRectMake(0, 0, 1, height);
    layer.anchorPoint = CGPointMake(0.5, 1);
    layer.position = CGPointMake(self.clockView.frame.size.width*0.5, self.clockView.frame.size.height*0.5);
    [self.clockView.layer addSublayer:layer];
}

- (void)timeChange
{
    // 获取日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSCalendarUnitSecond  | NSCalendarUnitMinute | NSCalendarUnitHour  fromDate:[NSDate date]];
    
    /// 秒钟开始旋转
    // 获取秒钟
    NSInteger curSec = cmp.second;
    CGFloat secAngle = curSec * perSecAngle;
    self.secLayer.transform = CATransform3DMakeRotation(angle2radio(secAngle),0, 0, 1);
    NSLog(@"%f",secAngle);
    //    self.secLayer.transform = CATransform3DRotate(self.secLayer.transform, angle2radio(6), 0, 0, 1);
    
    /// 分钟开始旋转
    // 获取分钟
    NSInteger curMin = cmp.minute;
    CGFloat minAngle = curMin * perMinAngle;
    self.minLayer.transform = CATransform3DMakeRotation(angle2radio(minAngle), 0, 0, 1);
    
    /// 时钟开始旋转
    // 获取时钟
    NSInteger curHour = cmp.hour;
    CGFloat hourAngle = curHour * perHourAngle + curMin * perMinHourA;
    self.hourLayer.transform = CATransform3DMakeRotation(angle2radio(hourAngle), 0, 0, 1);
}


#pragma mark - 之前的方法
- (void)setUpInit {
    // 时
    [self setUpahour];

    // 分
    [self setUpMinute];

    // 秒
    [self setUpSecond];
}

- (void)setUpSecond {
    CALayer *secondLayer = [[CALayer alloc] init];
    secondLayer.backgroundColor = [UIColor redColor].CGColor;
    secondLayer.frame = CGRectMake(0, 0, 1, 80);
    secondLayer.anchorPoint = CGPointMake(0.5, 1);
    secondLayer.position = CGPointMake(self.clockView.frame.size.width*0.5, self.clockView.frame.size.height*0.5);
    self.secLayer = secondLayer;
    [self.clockView.layer addSublayer:secondLayer];
}

- (void)setUpMinute {
    CALayer *minuteLayer = [[CALayer alloc] init];
    minuteLayer.backgroundColor = [UIColor blackColor].CGColor;
    minuteLayer.frame = CGRectMake(0, 0, 1, 70);
    minuteLayer.anchorPoint = CGPointMake(0.5, 1);
    minuteLayer.position = CGPointMake(self.clockView.frame.size.width*0.5, self.clockView.frame.size.height*0.5);
    self.minLayer = minuteLayer;
    [self.clockView.layer addSublayer:minuteLayer];
}

- (void)setUpahour {
    CALayer *hourLayer = [[CALayer alloc] init];
    hourLayer.backgroundColor = [UIColor blackColor].CGColor;
    hourLayer.frame = CGRectMake(0, 0, 1, 65);
    hourLayer.anchorPoint = CGPointMake(0.5, 1);
    hourLayer.position = CGPointMake(self.clockView.frame.size.width*0.5, self.clockView.frame.size.height*0.5);
    [self.clockView.layer addSublayer:hourLayer];
    self.hourLayer = hourLayer;
}

@end
