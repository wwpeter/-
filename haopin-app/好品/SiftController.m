//
//  SiftController.m
//  好品
//
//  Created by 朱明科 on 16/1/18.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "SiftController.h"

@interface SiftController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic)NSArray *dataArr;
@end

@implementation SiftController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArr = @[@"品类",@"设计师"];
    [self initUI];
}
-(void)initUI{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(100, 30);
    layOut.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layOut.minimumLineSpacing = 10;
    layOut.minimumInteritemSpacing = 10;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, 230, 50) collectionViewLayout:layOut];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:collectionView];
}
#pragma mark - collectionview data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [[UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0]CGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.textColor = [UIColor colorWithRed:102.0/255 green:96.0/255 blue:0 alpha:1.0];
    label.text = self.dataArr[indexPath.row];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    cell.backgroundView = label;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.dataArr[indexPath.row];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.tintColor = [UIColor colorWithRed:62.0/255 green:202.0/255 blue:72.0/255 alpha:1.0];
    if (self.didSelectedHandler) {
        self.didSelectedHandler(str);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
