//
//  ColerDB.h
//  haopin
//
//  Created by ww on 16/3/31.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorModel.h"
#import "FMDatabase.h"

@interface ColerDB : NSObject
+ (instancetype)sharedInstance;
/**
 *  增添数据
 *
 *  @param model 衣服详情里的功能
 */
- (void)addDetailModel:(ColorModel *)model;
/**
 *  查找
 *
 *  @param tag    图片对应的里面的所有图片
 *  @param detail <#detail description#>
 *
 *  @return 查找返回的数据
 */
- (NSMutableArray *)fetchByTag:(NSString *)tag andDetail:(NSString *)detail;
- (void)update:(ColorModel *)model;
/**
 *  删除
 *
 *  @param tag 整个图片的tag ，删除整个图片对应所有的
 */
- (void)deleteByTag:(NSString *)tag;
/**
 *  删除
 *
 *  @param tag
 *  @param colorID 当前的时间,操作的时间
 */
-(void)deleteByTag:(NSString *)tag andId:(NSString *)colorID;
@end
