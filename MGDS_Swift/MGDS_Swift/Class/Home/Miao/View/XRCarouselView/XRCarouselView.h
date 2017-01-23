//
//  XRCarouselView.h
//
//  Created by 肖睿 on 16/3/17.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XRCarouselView;

typedef void(^ClickBlock)(NSInteger index);

//pageControl的显示位置
typedef enum {
    PositionNone,           //默认值 == PositionBottomCenter
    PositionHide,           //隐藏
    PositionTopCenter,      //中上
    PositionBottomLeft,     //左下
    PositionBottomCenter,   //中下
    PositionBottomRight     //右下
} PageControlPosition;

// 转场类型
typedef NS_ENUM(NSInteger,TransitionType){
    TransitionCube,
    TransitionFade,
    TransitionPush,
    TransitionReveal,
    TransitionPageCurl,
    TransitionPageUnCurl,
    TransitionRipppleEffect,
    TransitionCameraIrisHollowOpen,
    TransitionCameraIrisHollowClose
};


@protocol XRCarouselViewDelegate <NSObject>

/**
 *  该方法用来处理图片的点击，会返回图片在数组中的索引
 *  代理与block二选一即可，若两者都实现，block的优先级高
 *
 *  @param carouselView 控件本身
 *  @param index        图片索引
 */
- (void)carouselView:(XRCarouselView *)carouselView didClickImage:(NSInteger)index;

@end




/**
 *  说明：要想正常使用，图片数组imageArray必须设置
 *  控件的frame必须设置，xib\sb创建的可不设置
 *  其他属性都有默认值，可不设置
 */
@interface XRCarouselView : UIView


/*
 这里没有提供修改占位图片的接口，如果需要修改，可直接到.m文件中
 搜索"placeholder"替换为你想要显示的图片名称，或者将原有的占位
 图片删除并修改你想要显示的图片名称为"placeholder"
 */


#pragma mark 属性
/**
 *  设置转场类型
 */
@property (nonatomic, assign) TransitionType transitionType;

/**
 *  设置分页控件位置，默认为PositionBottomCenter
 */
@property (nonatomic, assign) PageControlPosition pagePosition;


/**
 *  轮播的图片数组，可以是图片，也可以是网络路径
 */
@property (nonatomic, strong) NSArray *imageArray;


/**
 *  图片描述的字符串数组，应与图片顺序对应
 *
 *  图片描述控件默认是隐藏的
 *  设置图片描述后，会取消隐藏，显示在图片底部
 *  若之后又需要隐藏，只需将该属性设为nil即可
 */
@property (nonatomic, strong) NSArray *describeArray;

/**
 *  图片描述控件的背景颜色，默认为黑色半透明
 */
@property (nonatomic, strong) UIColor *desLabelBgColor;

/**
 *  图片描述控件的字体，默认为13号字体
 */
@property (nonatomic, strong) UIFont *desLabelFont;

/**
 *  图片描述控件的文字颜色，默认为白色
 */
@property (nonatomic, strong) UIColor *desLabelColor;


/**
 *  每一页停留时间，默认为5s，最少1s
 *  当设置的值小于1s时，则为默认值
 */
@property (nonatomic, assign) NSTimeInterval time;


/**
 *  点击图片后要执行的操作，会返回图片在数组中的索引
 */
@property (nonatomic, copy) ClickBlock imageClickBlock;


/**
 *  代理，用来处理图片的点击
 */
@property (nonatomic, weak) id<XRCarouselViewDelegate> delegate;


#pragma mark 构造方法
/**
 *  构造方法
 *
 *  @param imageArray 图片数组
 *  @param describeArray 图片描述数组
 *
 */
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;
+ (instancetype)carouselViewWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;
- (instancetype)initWithImageArray:(NSArray *)imageArray describeArray:(NSArray *)describeArray;
+ (instancetype)carouselViewWithImageArray:(NSArray *)imageArray describeArray:(NSArray *)describeArray;


#pragma mark 方法

/**
 *  开启定时器
 *  默认已开启，调用该方法会重新开启
 */
- (void)startTimer;


/**
 *  停止定时器
 *  停止后，如果手动滚动图片，定时器会重新开启
 */
- (void)stopTimer;


/**
 *  设置分页控件指示器的图片
 *  两个图片都不能为空，否则设置无效
 *  不设置则为系统默认
 *
 *  @param pageImage    其他页码的图片
 *  @param currentImage 当前页码的图片
 */
- (void)setPageImage:(UIImage *)pageImage andCurrentImage:(UIImage *)currentImage;


/**
 *  设置分页控件指示器的颜色
 *  不设置则为系统默认
 *
 *  @param color    其他页码的颜色
 *  @param currentColor 当前页码的颜色
 */
- (void)setPageColor:(UIColor *)color andCurrentPageColor:(UIColor *)currentColor;

/**
 *  清除沙盒中的图片缓存
 */
- (void)clearDiskCache;

@end
