//
//  DeleCombinController.m
//  好品
//
//  Created by 朱明科 on 16/1/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "DeleCombinController.h"
#import "DBManager.h"
#import "CombinCell.h"

@interface DeleCombinController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)UICollectionView *collectionView;
@end

@implementation DeleCombinController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self createData];
    [self initCollection];
}
-(void)delet:(UIButton *)button{
    for (NSInteger i = 0; i < self.deleArr.count; i ++) {
        Combin *combin = self.deleArr[i];
        [self.dataArr removeObject:combin];
        [[DBManager sharedInstance]deleteByDetailTimer:combin.combinDetail];
    }
    self.deleArr = nil;
    [self.collectionView reloadData];
}
-(void)done:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createData{
    self.dataArr = [[DBManager sharedInstance]fetchByYear:[_userDeft objectForKey:@"selectSTR"]];
    [self.collectionView reloadData];
}
-(void)initCollection{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(kItemWidth, kItemHeight);
    layOut.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layOut.minimumLineSpacing = 10;
    layOut.minimumInteritemSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 69, kWidth, kHeight-69) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsMultipleSelection = YES;//允许多选
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"CombinCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionView];
}
#pragma mark - collectionview data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CombinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    Combin *combin = self.dataArr[indexPath.row];
    cell.rootImageView.image = combin.combinImage;
    cell.timeLabel.text = combin.combinTime;
    cell.namelabel.text = combin.combinName;
    return cell;}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Combin *combin = self.dataArr[indexPath.row];
    CombinCell *cell = (CombinCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [[UIColor colorWithRed:84.0/255 green:207.0/255 blue:109.0/255 alpha:1.0]CGColor];
    [self.deleArr addObject:combin];
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    Combin *combin = self.dataArr[indexPath.row];
    CombinCell *cell = (CombinCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
    [self.deleArr removeObject:combin];
}
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
