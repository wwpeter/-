//
//  FullScreenExample.h
//  FSCalendar
//
//  Created by Wenchao Ding on 9/16/15.
//  Copyright (c) 2015 wenchaoios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"

typedef void(^blockHandler)(NSString *startString);

@interface FullScreenExampleViewController : UIViewController <FSCalendarDataSource,FSCalendarDelegate>

@property (weak, nonatomic) FSCalendar *calendar;
@property (assign, nonatomic) BOOL showsLunar;
@property (nonatomic, copy) blockHandler handler;

- (void)todayItemClicked:(id)sender;
- (void)lunarItemClicked:(id)sender;
- (void)setHandler:(blockHandler)handler;
@end