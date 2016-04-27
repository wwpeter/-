//
//  NewDetailKTController.m
//  haopin
//
//  Created by 朱明科 on 16/3/10.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "NewDetailKTController.h"
#import "NewAddKTController.h"
#import "NewKTDetail.h"
#import "NewKTDB.h"
#import "ZhuTiDB.h"
#import "NewAddKTViewController.h"
#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height
@interface NewDetailKTController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) NSUserDefaults *userDefault;//沙盒
@property (nonatomic) UICollectionView *collectionView;//上面的所有衣服
@property (nonatomic) NSMutableArray *dataArray;//存储所有衣服我数据
@property (nonatomic) NSArray *ganArrayNum;
@property(nonatomic)UIScrollView *rootScrollView;
@end

@implementation NewDetailKTController
#pragma mark - 懒加载
- (NSArray *)ganArrayNum {
    if (_ganArrayNum == nil) {
        _ganArrayNum = [NSArray array];
    }
    return _ganArrayNum;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma MARK - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefault = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.rootScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rootScrollView];
    
}
-(void)addButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 45, 44);
    [backButton setImage:[[UIImage imageNamed:@"return"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item1;
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    editButton.frame = CGRectMake(0, 0, 45, 44);
    [editButton setImage:[[UIImage imageNamed:@"edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = item2;
}
-(void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)edit:(UIButton *)button{
    NewAddKTViewController *newAddKtController = [[NewAddKTViewController alloc]init];
    newAddKtController.currentYear = self.currentYear;
    newAddKtController.currentData = self.currentDate;
    newAddKtController.yearAndDate = self.currentYearAndDate;
    newAddKtController.isEdit = YES;
    newAddKtController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newAddKtController animated:YES];
}
- (void)createUI {
    UIImageView *zhutiView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 250)];
    ZhuTiModel *model = [[ZhuTiDB sharedInstance]fetchKTByYear:self.currentYear andDate:self.currentDate andDetail:@"主题"];
    zhutiView.contentMode = UIViewContentModeScaleAspectFit;
    zhutiView.image = model.image;
    zhutiView.backgroundColor = [UIColor whiteColor];
    [self.rootScrollView addSubview:zhutiView];
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = kWidth/10.0;
    layOut.itemSize = CGSizeMake(itemWidth, itemWidth);
    layOut.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layOut.minimumInteritemSpacing = 5;
    layOut.minimumLineSpacing = 5;
    NSInteger line;
    if (self.dataArray.count<=10) {
        line = 1;
    }else{
        line = self.dataArray.count/10;
        if (self.dataArray.count%10 != 0) {
            ++line;
        }
    }
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 260, kWidth, line*itemWidth+20) collectionViewLayout:layOut];
    //collectionview的高度line*itemWidth+20
    _collectionView .backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ganCellID"];
    [self.rootScrollView addSubview:_collectionView];
    
    for (NSInteger i = 0; i < self.ganArrayNum.count; i ++) {
        UIImageView *ganImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (290+line*itemWidth)+(310*i), kWidth, 300)];
        ganImageView.backgroundColor = [UIColor whiteColor];
        ZhuTiModel *model = [[ZhuTiDB sharedInstance]fetchKTByYear:self.currentYear andDate:self.currentDate andDetail:self.ganArrayNum[i]];
        ganImageView.contentMode = UIViewContentModeScaleAspectFit;
        ganImageView.image = model.image;
        [self.rootScrollView addSubview:ganImageView];
    }
    CGFloat contentHeight = 380+line*itemWidth+self.ganArrayNum.count*300;
    self.rootScrollView.contentSize = CGSizeMake(0, contentHeight);
    self.rootScrollView.showsVerticalScrollIndicator = NO;
    self.rootScrollView.bounces = NO;
}

- (void)createData {
    self.dataArray = [[NewKTDB sharedInstance]fetchKTBySession:self.currentYear andDate:self.currentDate];
    self.ganArrayNum = [_userDefault objectForKey:self.currentYearAndDate];
    
}
#pragma mark - collection 所有货品
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"ganCellID" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]init];
    NewKTDetailModel *model = self.dataArray[indexPath.row];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = model.image;
    cell.backgroundView = imageView;
    
    UIImageView *markView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    markView.image = [UIImage imageNamed:@"xiaosanjiao.png"];
    [cell.backgroundView addSubview:markView];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, 20, 20)];
    numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row/2+1];
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.textColor = [UIColor darkGrayColor];
    
    [cell.backgroundView addSubview:numLabel];

    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [self addButton];
    [self createData];
    [self createUI];
}

@end
