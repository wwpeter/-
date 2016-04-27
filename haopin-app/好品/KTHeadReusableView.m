//
//  KTHeadReusableView.m
//  好品
//
//  Created by 朱明科 on 15/12/29.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "KTHeadReusableView.h"

@implementation KTHeadReusableView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *lable = [[UILabel alloc]initWithFrame:self.bounds];
        [self addSubview:lable];
        //self.backgroundColor = [UIColor colorWithRed:239.0/255  green:239.0/255  blue:240.0/255  alpha:1.0];
    }
    return self;
}
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    ((UILabel *)(self.subviews[0])).text = titleStr;
}
@end
