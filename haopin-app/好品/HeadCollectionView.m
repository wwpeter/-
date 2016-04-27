//
//  HeadCollectionView.m
//  好品
//
//  Created by 朱明科 on 15/12/21.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "HeadCollectionView.h"

@implementation HeadCollectionView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0];
        [self addSubview:label];
    }
    return self;
}
-(void)setAboutStr:(NSString *)aboutStr{
    _aboutStr = aboutStr;
   ((UILabel *)(self.subviews[0])).text = aboutStr;
}
@end
