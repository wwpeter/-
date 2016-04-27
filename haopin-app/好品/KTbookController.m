//
//  KTbookController.m
//  好品
//
//  Created by 朱明科 on 15/12/9.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "KTbookController.h"
#import "AddKTController.h"
#import "KTDBManager.h"
#import "KTHeadReusableView.h"
#import "DetailDB.h"
#import "KTDetailController.h"

#define kItemWidth   [UIScreen mainScreen].bounds.size.width
#define kItemHeight   [UIScreen mainScreen].bounds.size.height
@interface KTbookController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic)NSMutableArray *dataArray;//数据源
@property(nonatomic)UICollectionView *collectionView;
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)NSMutableArray *sectionsArray;//返回的分区
@property(nonatomic)NSMutableArray *headNameArray;
@property(nonatomic,copy)NSString *returnYaerStr;//返回的年份
@property(nonatomic)NSInteger nums;
@property(nonatomic)UIButton *addBtn;
@end
@implementation KTbookController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)headNameArray{
    if (_headNameArray == nil) {
        _headNameArray = [[NSMutableArray alloc]init];
    }
    return _headNameArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self createData];
    [self addButton];
    [self createUI];
}
-(void)addButton{
    //添加按钮
    self.addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _addBtn.frame = CGRectMake(0, 0, 60, 40);
    [_addBtn setTitleColor:[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0] forState:UIControlStateNormal];
    [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    if (self.nums == 0) {
        [_addBtn setTitle:@"新增" forState:UIControlStateNormal];
    }else{
        [_addBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    [_addBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:_addBtn];
    
    //管理按钮
    UIButton *GLBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    GLBtn.frame = CGRectMake(0, 0, 60, 40);
    [GLBtn addTarget:self action:@selector(GLClick) forControlEvents:UIControlEventTouchUpInside];
    [GLBtn setTitle:@"管理" forState:UIControlStateNormal];
    [GLBtn setTitleColor:[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0] forState:UIControlStateNormal];
    [GLBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    UIBarButtonItem *GLItem = [[UIBarButtonItem alloc]initWithCustomView:GLBtn];
    
    self.navigationItem.rightBarButtonItems = @[GLItem,addItem];

}
-(void)createData{
    self.nums = 0;
    //获取年份
    self.returnYaerStr = [_userDeft objectForKey:@"selectSTR"];
    //获取分区，也就是有几个波段
    if (self.returnYaerStr == nil) {
        self.sectionsArray = nil;
    }else{
        self.sectionsArray = [NSMutableArray arrayWithArray:[_userDeft objectForKey:self.returnYaerStr]];
    }
    //记录每个分区的数据  数据库
//    for (NSInteger i = 0; i < _sectionsArray.count; i ++) {
//        NSMutableArray *arr = [[KTDBManager sharedInstance]fetchBySession:self.returnYaerStr bod:self.sectionsArray[i]];
//        self.nums += arr.count;
//        if (arr.count != 0) {
//            [self.dataArray addObject:arr];
//            [self.headNameArray addObject:self.sectionsArray[i]];
//        }
//    }
    /*
     *
     *
     *铺满整个屏幕
     *
     *
     */
    for (NSInteger i = 0; i < _sectionsArray.count; i ++) {
        NSMutableArray *arr = [[DetailDB sharedInstance]fetchBySession:self.returnYaerStr bod:self.sectionsArray[i]];
        if (arr.count != 0) {
            self.nums += 1;
            [self.dataArray addObject:arr];
            [self.headNameArray addObject:self.sectionsArray[i]];
        }
    }
    [self.collectionView reloadData];
}
//根据设置里的波段数量显示collection的section数量
-(void)createUI{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
//     NSInteger tmpNum = kItemHeight-50*_sectionsArray.count-100;
//    if (_sectionsArray.count == 0) {
//        layOut.itemSize = CGSizeMake(kItemWidth, kItemHeight);
//    }else if(_sectionsArray.count == 1 || _sectionsArray.count == 2){
//        layOut.itemSize = CGSizeMake(kItemWidth, tmpNum/2);
//    }else{
//        layOut.itemSize = CGSizeMake(kItemWidth, tmpNum/_sectionsArray.count);
//    }
    NSInteger tmpNum = kItemHeight-50*_headNameArray.count-64-49;
    if (self.sectionsArray.count == 0) {
        layOut.itemSize = CGSizeMake(kItemWidth, kItemHeight);
    }else{
        layOut.itemSize = CGSizeMake(kItemWidth, tmpNum/self.sectionsArray.count);
    }
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.minimumLineSpacing = 10;
    layOut.minimumInteritemSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kItemWidth, kItemHeight-64-49) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    layOut.headerReferenceSize = CGSizeMake(0, 50);
   
    //注册cell
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELLID"];
    [self.view addSubview:_collectionView];
}
#pragma mark - collect dele
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _nums;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //dataArray里存放的是一个个波段数组
//    NSArray *arr = self.dataArray[section];
//    return arr.count;
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    KTModel *ktModel = self.dataArray[indexPath.section][indexPath.row];
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kItemWidth, (kItemHeight-50*_sectionsArray.count)/_sectionsArray.count)];
//    imageView.image = ktModel.ktImage;
//    cell.backgroundView = imageView;
    
    /*
     *
     *
     *
     */
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
    UIView *bgView = [[UIView alloc]init];
    NSMutableArray *deArr = self.dataArray[indexPath.section];
    NSInteger number = deArr.count;
    double maxOrignX = 0;
    double maxWidth = 0;
    for (NSInteger i = 0; i < number; i++) {
        DetailModel *detailModel = deArr[i];
        //orignx origny 随着波段的增加，自动改变。。。
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(detailModel.orignX, detailModel.orignY, detailModel.frameWidth, detailModel.frameHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = detailModel.image;
        
        [bgView addSubview:imageView];
        
        if (detailModel.orignX >= maxOrignX) {
            maxOrignX = detailModel.orignX;
            maxWidth = detailModel.frameWidth+100;
        }
        bgView.frame = CGRectMake(0, 0, maxOrignX+maxWidth, 350);
    }
    UIGraphicsBeginImageContext(bgView.bounds.size);
    [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewToImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kItemWidth, (kItemHeight-50*_sectionsArray.count)/_sectionsArray.count)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = viewToImage;
    cell.backgroundView = imageView;
    return cell;
}
//点击一个cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    KTDetailController *ktDetail = [[KTDetailController alloc]init];
    [self presentViewController:ktDetail animated:YES completion:nil];
}
//头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *headID = [NSString stringWithFormat:@"headerID%ld",(long)indexPath.section];
    [_collectionView registerClass:[KTHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headID];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // 如果是头视图
        KTHeadReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headID forIndexPath:indexPath];
        headView.titleStr = [NSString stringWithFormat:@"   %@",_headNameArray[indexPath.section]];
        return headView;
    }
    return nil;
}
//添加按钮
-(void)click{
    AddKTController *addKTController = [[AddKTController alloc]init];
    [self presentViewController:addKTController animated:YES completion:nil];
}
//管理按钮
-(void)GLClick{
    self.collectionView.layer.borderWidth = 2.0;
    self.collectionView.layer.borderColor = [[UIColor colorWithRed:84.0/255 green:207.0/255 blue:109.0/255 alpha:1.0]CGColor];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除此KT板" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *DoneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[KTDBManager sharedInstance]deleteBySession:self.returnYaerStr];
        [[DetailDB sharedInstance]deleteBySession:self.returnYaerStr];
        [self createData];
        self.collectionView.layer.borderWidth = 0;
        [_addBtn setTitle:@"新增" forState:UIControlStateNormal];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.collectionView.layer.borderWidth = 0;
    }];
    [alert addAction:DoneAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//又是返回数据不会自动刷新的问题
-(void)viewWillAppear:(BOOL)animated{
    self.dataArray = nil;
    self.headNameArray = nil;
    [self createData];
}
@end
