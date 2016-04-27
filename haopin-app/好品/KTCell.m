//
//  KTCell.m
//  好品
//
//  Created by 朱明科 on 15/12/30.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "KTCell.h"

#define kWidth   [UIScreen mainScreen].bounds.size.width
@implementation KTCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 350)];
    _scrollView.contentSize = CGSizeMake(kWidth*8, 0);
    _scrollView.bounces = NO;
    _scrollView.userInteractionEnabled = YES;
    //_scrollView.backgroundColor = [UIColor redColor];
    //_scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
}
@end
