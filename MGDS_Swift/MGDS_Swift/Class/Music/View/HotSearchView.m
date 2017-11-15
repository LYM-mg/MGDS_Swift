//
//  HotSearchView.m
//  MGLoveFreshBeen
//
//  Created by ming on 16/8/11.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "HotSearchView.h"

@interface HotSearchView ()

/** 回调  */
@property (nonatomic,copy) void (^searchButtonClickCallback)(UIButton *sender);
/** searchLabel */
@property (nonatomic,weak) UILabel *searchTitleLabel;
@property (nonatomic,strong) NSMutableArray<UIButton *> *btnArray;

@end


@implementation HotSearchView

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    self.searchTitleLabel.frame = CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 30, 30);
}

#pragma mark - 私有方法
/**
 *  创建UI
 */
- (void)setUpUI{
    UILabel *searchTitleLabel = [[UILabel alloc] init];
    searchTitleLabel.frame = CGRectMake(10, 0, self.frame.size.width - 30, 30);
    searchTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    searchTitleLabel.textAlignment = NSTextAlignmentLeft;
    searchTitleLabel.textColor = [UIColor colorWithRed:140 green:140 blue:140 alpha:1.0];
    [self addSubview:searchTitleLabel];
    _searchTitleLabel = searchTitleLabel;

}

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
- (instancetype)initWithFrame:(CGRect)frame searchTitleText:(NSString *)searchTitleText searchButtonTitleTexts:(NSArray *)searchButtonTitleTexts searchButton:(void(^)(UIButton *sender))searchButtonClickCallback{
    if (self = [super initWithFrame:frame]) {
//        [self setUpUI];
        
//        self.searchTitleLabel.text = searchTitleText;
        
        CGFloat btnW = 0;
        CGFloat btnH  = 30;
        CGFloat addW  = 30;
        CGFloat marginX  = 10;
        CGFloat marginY  = 5;
        CGFloat lastX = 10;
        CGFloat lastY = 10;
        
        NSInteger count = searchButtonTitleTexts.count;
        for (int i = 0; i < count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:searchButtonTitleTexts[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn.titleLabel sizeToFit];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 15;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:1.0].CGColor;
            [btn addTarget:self action:@selector(hotSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btnW = btn.titleLabel.frame.size.width + addW;
            
            if (frame.size.width - lastX > btnW) {
                btn.frame = CGRectMake(lastX, lastY, btnW, btnH);
            } else {
                btn.frame = CGRectMake(marginX, lastY + marginY + btnH, btnW, btnH);
            }
            
            lastX = CGRectGetMaxX(btn.frame) + marginX;
            lastY = btn.frame.origin.y;
            [self.btnArray addObject:btn];
            [self addSubview:btn];
        }
        self.searchHeight = CGRectGetMaxY(self.btnArray.lastObject.frame)+marginX;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.searchHeight);
        [self layoutIfNeeded];
        self.searchButtonClickCallback = searchButtonClickCallback;
    }
    return self;
}

/**
 *  监听按钮点击
 *
 *  @param btn 按钮本身
 */
- (void)hotSearchBtnClick:(UIButton *)btn {
    if (self.searchButtonClickCallback) {
        self.searchButtonClickCallback(btn);
    }
}




@end
