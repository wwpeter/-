//
//  KTDetailController.m
//  好品
//
//  Created by 朱明科 on 16/1/5.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "KTDetailController.h"
#import "AddKTController.h"
#import "KTCell.h"
#import "DetailDB.h"
#import "KTHeadReusableView.h"
#import "DetailModel.h"

#define kItemWidth   [UIScreen mainScreen].bounds.size.width
#define kItemHeight 350
@interface KTDetailController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic)NSMutableArray *dataArray;//数据源
@property(nonatomic)UICollectionView *collectionView;
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)NSMutableArray *sectionsArray;//返回的分区
@property(nonatomic,copy)NSString *returnYaerStr;//返回的年份

@end

@implementation KTDetailController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self addTitleView];
    [self createData];//读取数据
    [self createUI];
}
-(void)addTitleView{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kItemWidth, 49)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    //返回
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.frame = CGRectMake(10, 10, 23, 23);
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"trturn02"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnclick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:returnBtn];
    //编辑
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    editBtn.frame = CGRectMake(kItemWidth-80, 10, 60, 40);
    [editBtn setTitleColor:[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0] forState:UIControlStateNormal];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    editBtn.tintColor = [UIColor clearColor];
    [editBtn addTarget:self action:@selector(editclick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:editBtn];
    //标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kItemWidth-200)/2.0, 5, 200, 30)];
    label.text = @"详情";
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:label];
}
-(void)createUI{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(kItemWidth, kItemHeight);
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.minimumLineSpacing = 10;
    layOut.minimumInteritemSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 69, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-75) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    layOut.headerReferenceSize = CGSizeMake(0, 50);
    //注册cell
    //[_collectionView registerClass:[KTCell class] forCellWithReuseIdentifier:@"cellsID"];
    //注册headview头视图
    [_collectionView registerClass:[KTHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"headerID"];
    [self.view addSubview:_collectionView];
}
-(void)createData{
    //获取年份
    self.returnYaerStr = [_userDeft objectForKey:@"selectSTR"];
    //获取分区(波段)
    self.sectionsArray = [NSMutableArray arrayWithArray:[_userDeft objectForKey:self.returnYaerStr]];
    //记录每个分区的数据  数据库
    //从DetailDB中获取数据，贴数据
    for (NSInteger i = 0; i < _sectionsArray.count; i ++) {
        NSMutableArray *arr = [[DetailDB sharedInstance]fetchBySession:self.returnYaerStr bod:self.sectionsArray[i]];//存放的是一个个detailModel对象
        [self.dataArray addObject:arr];
    }
    [self.collectionView reloadData];
}
-(void)returnclick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击编辑跳转到添加页面
-(void)editclick{
    AddKTController *addKt = [[AddKTController alloc]init];
    [self presentViewController:addKt animated:YES completion:nil];
}
#pragma mark - collect dele
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _sectionsArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"cellsID%ld",(long)indexPath.section];
    [_collectionView registerClass:[KTCell class] forCellWithReuseIdentifier:cellID];
    KTCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSMutableArray *deArr = self.dataArray[indexPath.section];
    NSInteger number = deArr.count;
    double maxOrignX = 0;
    double maxWidth = 0;
    for (NSInteger i = 0; i < number; i++) {
        DetailModel *detailModel = deArr[i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(detailModel.orignX, detailModel.orignY, detailModel.frameWidth, detailModel.frameHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = detailModel.image;
        [cell.scrollView addSubview:imageView];
        if (detailModel.orignX >= maxOrignX) {
            maxOrignX = detailModel.orignX;
            maxWidth = detailModel.frameWidth+20;
        }
    }
    cell.scrollView.contentSize = CGSizeMake(maxOrignX+maxWidth, 0);
    return cell;
}
//点击一个cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AddKTController *addKt = [[AddKTController alloc]init];
    addKt.haveDetailArr = [[DetailDB sharedInstance]fetchBySession:_returnYaerStr bod:_sectionsArray[indexPath.section]];
    [self.navigationController pushViewController:addKt animated:YES];
}
//头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // 如果是头视图
        KTHeadReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID" forIndexPath:indexPath];
        headView.titleStr = [NSString stringWithFormat:@"   %@",_sectionsArray[indexPath.section]];
        return headView;
    }
    return nil;
}
-(void)viewWillAppear:(BOOL)animated{
    self.dataArray = nil;
    [self createData];
}
@end
