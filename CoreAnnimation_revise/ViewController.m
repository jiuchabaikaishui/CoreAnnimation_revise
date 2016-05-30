//
//  ViewController.m
//  CoreAnnimation_revise
//
//  Created by 綦 on 16/5/27.
//  Copyright © 2016年 QSP. All rights reserved.
//

#import "ViewController.h"

#define Screen_Rect             [UIScreen mainScreen].bounds
#define Screen_Width            [UIScreen mainScreen].bounds.size.width
#define Screen_Height           [UIScreen mainScreen].bounds.size.height
#define Status_Bar_Height       [UIApplication sharedApplication].statusBarFrame.size.height

@interface ViewController ()

@property (strong, nonatomic) NSArray *layers;
@property (weak, nonatomic) CALayer *layer;

@end

@implementation ViewController

#pragma mark - 属性方法
- (NSArray *)layers
{
    if (_layers == nil) {
        _layers = [NSArray array];
    }
    
    return _layers;
}

#pragma mark - 控制器周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layers = [self creatLayersWithCount:5];
    [self creatTapGusturesWithCount:self.layers.count];
}

#pragma mark - 触摸点击方法
/**
 *  点击控制器视图的touchesBegan方法
 */
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self exeBasicAnimation:self.layer];
//}
/**
 *  点击控制器视图的手势方法
 *
 *  @param sender 点击手势
 */
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    //NSLog(@"%i",(int)sender.numberOfTapsRequired);
    switch (sender.numberOfTapsRequired) {
        case 1:
        {
            [self exeBasicAnimation:self.layers[sender.numberOfTapsRequired - 1]];
        }
            break;
            
        default:
            break;
    };
}

#pragma mark - 自定义方法
/**
 *  执行基本动画
 *
 *  @param layer 动画产生的CALayer
 */
- (void)exeBasicAnimation:(CALayer *)layer
{
    //CALayer的position是其对称中心相对于父视图的位置
    //NSLog(@"%@",NSStringFromCGPoint(layer.position));
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"position.y";
    basicAnimation.fromValue = @(layer.position.y);
    basicAnimation.toValue = @(Screen_Height - layer.position.y + Status_Bar_Height);
    basicAnimation.duration = 1.0;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    [layer addAnimation:basicAnimation forKey:nil];
}
/**
 *  创建Tap点击手势
 *
 *  @param layers 添加tap手势到对应的图层数组
 */
- (void)creatTapGusturesWithCount:(NSInteger)count
{
    if (count > 0) {
        UITapGestureRecognizer *tap = nil;
        UITapGestureRecognizer *lastTap = nil;
        for (int index = 0; index < count; index++) {
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [self.view addGestureRecognizer:tap];
            tap.numberOfTapsRequired = index + 1;
            //是否为第一个手势
            if (lastTap) {
                /*
                 该方法会让当前手势对象根据指定对象状态来进行下一步操作。如果指定对象进入Begin状态，当前对象直接进入Failed；如果指定对象进入Failed或Cancel状态，当前对象会进入Begin状态。这里就涉及到了不同手势之间执行的问题。（如果想要单击和双击都要执行，并分别执行不同的逻辑，这里可以先让单机等待双击失败在执行，但这样会导致单击事件稍微延迟执行，因为单击事件需要等待双击事件失败）。
                 */
                [lastTap requireGestureRecognizerToFail:tap];
            }
            lastTap = tap;
        }
    }
}
/**
 *  创建CALayer数组
 *
 *  @param count 创建多少个
 *
 *  @return CALayer数组
 */
- (NSArray *)creatLayersWithCount:(NSInteger)count
{
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:1];
    int totalColumn = 3;
    CGFloat W = Screen_Width/totalColumn;
    
    CGFloat margin_T = Status_Bar_Height;
    for (int i = 0; i < count; i++) {
        int column = i%totalColumn;
        int row = i/totalColumn;
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [self randomColor].CGColor;
        layer.frame = CGRectMake(column*W, margin_T + row*W, W, W);
        [self.view.layer addSublayer:layer];
        [mArr addObject:layer];
    }
    
    return [NSArray arrayWithArray:mArr];
}
/**
 *  获取一个随机的颜色
 *
 *  @return 随机颜色
 */
- (UIColor *)randomColor
{
    int randomR = arc4random()%256;
    int randomG = arc4random()%256;
    int randomB = arc4random()%256;
    
    return [UIColor colorWithRed:randomR/255.0 green:randomG/255.0 blue:randomB/255.0 alpha:1];
}

@end
