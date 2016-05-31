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
        case 2:
        {
            [self exeKeyfromAnimation:self.layers[sender.numberOfTapsRequired - 1]];
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
    //1.创建动画对象
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    
    //2.设置动画对象
    /*
         keyPath:决定执行怎样的动画，调整哪个属性来执行动画。
         fromValue:属性值丛什么值开始执行动画。
         toValue:属性值到达什么值结束动画。
         byVale:属性值增加了多少值之后结束动画。
         duration:动画持续时间。
         
         注意：以下两个属性结合起来用能让图层保持动画结束后的状态。
             removedOnCompletion:执行完动画后是否移除该动画。
             fillMode:动画保持的状态。
             fillMode的作用就是决定当前对象过了非active时间段的行为. 比如动画开始之前,动画结束之后。如果是一个动画CAAnimation,则需要将其removedOnCompletion设置为NO,要不然fillMode不起作用.
             fillMode取值：
                 1.kCAFillModeRemoved： 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态 。
                 2.kCAFillModeForwards： 当动画结束后,layer会一直保持着动画最后的状态
                 3.kCAFillModeBackwards： 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
                 4.kCAFillModeBoth： 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.
     */
    basicAnimation.keyPath = @"position.y";
    basicAnimation.fromValue = @(layer.position.y);
    basicAnimation.toValue = @(Screen_Height - layer.position.y + Status_Bar_Height);
    basicAnimation.duration = 1.0;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    //3.将动画对象添加到图层
    [layer addAnimation:basicAnimation forKey:nil];
}
- (void)exeKeyfromAnimation:(CALayer *)layer
{
    //1.创建帧动画对象
    CAKeyframeAnimation *keyframeAni = [CAKeyframeAnimation animation];
    
    //1.设置动画属性
    /*
     values:指明整个动画过程中的关键帧点，需要注意的是，起点必须作为values的第一个值。
     
     keyTimes:该属性是一个数组，用以指定每个子路径(AB,BC,CD)的时间。如果你没有显式地对keyTimes进行设置，则系统会默认每条子路径的时间为：ti=duration/(5-1)，即每条子路径的duration相等，都为duration的1\4。当然，我们也可以传个数组让物体快慢结合。例如，你可以传入{0.0, 0.1,0.6,0.7,1.0}，其中首尾必须分别是0和1，因此tAB=0.1-0, tCB=0.6-0.1, tDC=0.7-0.6, tED=1-0.7.....
     
     path:动画运动的路径。
     
     repeatCount:动画重复次数。
     
     timingFunctions:这个属性用以指定时间函数，控制动画节奏，类似于运动的加速度，有以下几种类型。记住，这是一个数组，你有几个子路径就应该传入几个元素
         属性值描述：
             1 kCAMediaTimingFunctionLinear//线性
             2 kCAMediaTimingFunctionEaseIn//淡入
             3 kCAMediaTimingFunctionEaseOut//淡出
             4 kCAMediaTimingFunctionEaseInEaseOut//淡入淡出
             5 kCAMediaTimingFunctionDefault//默认
     
     calculationMode：该属性决定了物体在每个子路径下是跳着走还是匀速走，跟timeFunctions属性有点类似
         属性值描述：
             1 const kCAAnimationLinear//线性，默认
             2 const kCAAnimationDiscrete//离散，无中间过程，但keyTimes设置的时间依旧生效，物体跳跃地出现在各个关键帧上
             3 const kCAAnimationPaced//平均，keyTimes跟timeFunctions失效
             4 const kCAAnimationCubic//平均，同上
             5 const kCAAnimationCubicPaced//平均，同上
     */
    keyframeAni.keyPath = @"position";
    CGFloat W = layer.frame.size.width;
    CGFloat Y = layer.position.y;
    
    //使用values做帧动画
    //keyframeAni.values = @[[NSValue valueWithCGPoint:layer.position], [NSValue valueWithCGPoint:CGPointMake(W/2, Y)], [NSValue valueWithCGPoint:CGPointMake(W/2, Screen_Height - layer.position.y + Status_Bar_Height)], [NSValue valueWithCGPoint:CGPointMake(Screen_Width - W/2, Screen_Height - layer.position.y + Status_Bar_Height)], [NSValue valueWithCGPoint:CGPointMake(Screen_Width - W/2, layer.position.y)], [NSValue valueWithCGPoint:layer.position]];
    //keyframeAni.duration = 5;
    //CGFloat unitTime = 1/12.0;
    //keyframeAni.keyTimes = @[@0, @(1*unitTime), @(5*unitTime), @(7*unitTime), @(11*unitTime), @(12*unitTime)];
    
    //使用path做帧动画
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, nil, CGRectMake(W/2, Y, Screen_Width - W, Screen_Height - W - Status_Bar_Height));
    keyframeAni.path = path;
    CGPathRelease(path);
    keyframeAni.duration = 5;
    
    keyframeAni.removedOnCompletion = NO;
    [keyframeAni setFillMode:kCAFillModeForwards];
    
    //3.添加动画到对应CALayer
    [layer addAnimation:keyframeAni forKey:nil];
}

- (void)exeTransitionAnimation:(CALayer *)layer
{
    //创建动画对象
    CATransition *transitionAni = [CATransition animation];
    
    //设置动画属性
    transitionAni.duration = 0.2;
    
    //添加动画到对应的图层
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
