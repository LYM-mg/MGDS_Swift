//
//  HotSearchView.h
//  MGLoveFreshBeen
//
//  Created by ming on 16/8/11.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotSearchView : UIView
/** searchHeight */
@property (nonatomic, assign) CGFloat searchHeight;

/**
 *  便利构造方法
 *
 *  @param frame                     尺寸
 *  @param searchTitleText           标题文字
 *  @param searchButtonTitleTexts    按钮文字
 *  @param searchButtonClickCallback 按钮回调
 *
 *  @return HotSearchView
 */
- (instancetype)initWithFrame:(CGRect)frame searchTitleText:(NSString *)searchTitleText searchButtonTitleTexts:(NSArray *)searchButtonTitleTexts searchButton:(void(^)(UIButton *sender))searchButtonClickCallback;

@end
