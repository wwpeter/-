//
//  NewAddKTViewController.m
//  haopin
//
//  Created by ww on 16/3/22.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "NewAddKTViewController.h"
#import "DataBase.h"
#import "ClothPhoto.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ChooseController.h"
#import "MenuPopController.h"
#import "ChangeColorController.h"
#import "NewKTDetail.h"//杆的数据
#import "NewKTDB.h"//上货周期的数据
#import "KuZiDB.h"
#import "ZhuTiModel.h"
#import "ZhuTiDB.h"
#import "ScrollDB.h"
#import "ScrollModel.h"
#import "BoduanViewCell.h"
#define kBordColor [[UIColor colorWithRed:84.0/255 green:207.0/255 blue:109.0/255 alpha:1.0]CGColor]
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface NewAddKTViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate>
@property (nonatomic     ) BOOL             yiJaiBOOL;
@property (nonatomic     ) UICollectionView *ganCollectionView;//展示选的衣服所以得东
@property (nonatomic     ) UICollectionView *kuZiCollection;//增加裤子的视图
@property (nonatomic     ) NSMutableArray   *kuZiArray;//裤子的数据
@property (nonatomic     ) UITableView      *tableMenuView;//滚动菜单栏
@property (nonatomic     ) UIView           *goBackView;//选的上的 返回按钮
@property (nonatomic     ) CGRect           viewFrame;//菜单栏的frame

@property (nonatomic     ) UIView           *detailHeadView;//返回按钮的视图
@property (nonatomic     ) UILabel          *detailMidLable;
@property (nonatomic     ) NSMutableArray   *toolArr;
@property (nonatomic     ) NSMutableArray   *dataArray;//下面的主要信息和杆
@property (nonatomic     ) NSMutableArray   *detailArray;//类型的主要信息
@property (nonatomic     ) NSMutableArray   *ganArray;//展示选的衣服所以得东西
@property (nonatomic     ) NSUserDefaults   *userDeft;//沙河目录
@property (nonatomic     ) UICollectionView *collectionMenuView;//选项菜单栏
@property (nonatomic     ) UIView           *ganView;//杆视图

@property (nonatomic     ) UITextView       *currentTextView;
@property (nonatomic     ) UIImageView      *changeView;
@property (nonatomic     ) UIImage          *changeImage;
@property (nonatomic     ) UIButton         *addGanBtn;//增加杆数按钮
@property (nonatomic     ) NSInteger        currentTag;//当前的tag,正反按钮使用
@property (nonatomic     ) BOOL             xuanZhouQi;
@property (nonatomic) ChooseController *chooseController;//选择上货周期子视图控制器
@property (nonatomic     ) BOOL           selectDate;//选择了上货周期
@property (nonatomic     ) NSMutableArray *ganDetailArr;//每个杆上的数据
@property (nonatomic     ) UIScrollView   *resultScrollView;
@property (nonatomic     ) BOOL           haveChanged;//已经编辑过，点击下个货杆要提示先保存
//@property(nonatomic)BOOL yesOrNo;//返回的时候判断，是不是修改过，修改过就弹出警告框
@property (nonatomic     ) UICollectionView *boDuanCollection;
@property (nonatomic     ) BOOL    kuZiBool;
@property (nonatomic     ) CGFloat pidWidth;//裤子的
@property (nonatomic     ) CGFloat pidWidth1;//上衣的
@property (nonatomic     ) CGFloat pidWidth2;//衣架的
@property (nonatomic     ) NSTimer *timer;
@property (nonatomic     ) BOOL    panDuanBool;//判断货品的变化
@property (nonatomic     ) BOOL    fanHuiBool;
@property (nonatomic     ) NSArray *arr;//六杆
@property (nonatomic, copy) NSString *detailStr;//判断是杆货还是主题
@property (nonatomic, copy) NSString *timerTag;
@property (nonatomic, copy) NSString *STR;//当前的年份
@property (nonatomic, copy) NSString *didSelectType;//记录选中的品类
@end

@implementation NewAddKTViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.title = @"编辑KT板";
    //self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
    self.currentGan = @"第一杆";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[UIColor whiteColor]};
    //self.navigationController.navigationBarHidden = YES;
    self.panDuanBool = NO;
    self.haveChanged = NO;
    self.pidWidth    = 0;
    _pidWidth1       = 0;
    _userDeft        = [NSUserDefaults standardUserDefaults];
    self.currentYear = [_userDeft objectForKey:@"selectSTR"];
    [self.view addSubview:self.ganView];
   
    [self addButton];
    [self createGanCollection];
    [self createKuZI];
   
   
    [self createData];
    self.arr = [NSArray arrayWithObjects:@"第一杆",@"第二杆", @"第三杆", @"第四杆", @"第五杆", @"第六杆",  nil];
    [self createBoDuan];
     [self xuanZeZhuTi];
}
- (void)createKuZI {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize                = CGSizeMake(120, 150);
    layOut.sectionInset            = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.minimumInteritemSpacing = 0;
    layOut.minimumLineSpacing      = 0;
    layOut.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
    
    self.kuZiCollection  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 155, self.view.frame.size.width, 150.1) collectionViewLayout:layOut];
    _kuZiCollection.backgroundColor                = [UIColor whiteColor];
    _kuZiCollection.delegate                       = self;
    _kuZiCollection.dataSource                     = self;
    _kuZiCollection.showsHorizontalScrollIndicator = NO;
    [_kuZiCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"kuZiCellID"];
    [self.view addSubview:_kuZiCollection];

}

- (void)createBoDuan {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize                = CGSizeMake(90, 55);
    layOut.sectionInset            = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.minimumInteritemSpacing = 0;
    layOut.minimumLineSpacing      = 0;
    layOut.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
    
    self.boDuanCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(self.view.frame.size.width -90, 357, self.view.frame.size.width, self.view.frame.size.height - 360) collectionViewLayout:layOut];
    _boDuanCollection.backgroundColor = [UIColor whiteColor];
    _boDuanCollection.delegate        = self;
    _boDuanCollection.dataSource      = self;
    //[_boDuanCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"boDuanCellID"];
    [_boDuanCollection registerClass:[BoduanViewCell class] forCellWithReuseIdentifier:@"boDuanCellID"];
    [self.view addSubview:_boDuanCollection];
}

-(ChooseController *)chooseController{
    if (_chooseController == nil) {
        _chooseController = [[ChooseController alloc]init];
        _chooseController.view.frame = CGRectMake(300, 100, self.view.frame.size.width-600, 500);
        __weak typeof(self)weakself = self;
        [_chooseController setSelectHandler:^(NSString *str,BOOL chosed) {
        weakself.currentData        = [NSString stringWithString:str];
        weakself.yearAndDate        = [NSString stringWithFormat:@"%@%@",weakself.currentYear,weakself.currentData];
        weakself.selectDate         = chosed;
        }];
    }
    return _chooseController;
}
- (NSMutableArray *)ganDetailArr {
    if (_ganDetailArr==nil) {
        _ganDetailArr = [NSMutableArray array];
    }
    return _ganDetailArr;
}
- (NSMutableArray *)kuZiArray {
    if (!_kuZiArray) {
        _kuZiArray = [NSMutableArray array];
    }
    return _kuZiArray;
}
- (NSMutableArray *)detailArray {
    if (_detailArray == nil) {
        _detailArray = [NSMutableArray array];
    }
    return _detailArray;
}
- (NSMutableArray *)dataArray {
    if (_dataArray ==nil) {
        NSString *type = [NSString stringWithFormat:@"%@type",[_userDeft objectForKey:@"selectSTR"]];
        NSLog(@"%@",type);
        NSArray *array = [_userDeft objectForKey:type];
        _dataArray     = [NSMutableArray arrayWithArray:array];
       // [_dataArray addObject:[NSString stringWithFormat:@"衣架"]];
    }
    return _dataArray;
}
- (NSMutableArray *)ganArray {
    if (_ganArray == nil) {
        _ganArray = [NSMutableArray array];
    }
    return _ganArray;
}
//衣服杆
- (UIView *)ganView {
    if (!_ganView) {
        _ganView = [[UIView alloc] initWithFrame:CGRectMake(5, 300+60, self.view.frame.size.width-100, 355)];
        _ganView.backgroundColor        = [UIColor whiteColor];
        _ganView.userInteractionEnabled = YES;
        UIImageView *imageView          = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-100, 341)];
        imageView.image                 = [UIImage imageNamed:@"HY_yijia_14"];
        [_ganView addSubview:imageView];
        [self.view addSubview:_ganView];
        //[self addYiJia];
        //if (self.isEdit) {
            self.ganDetailArr = nil;
            self.ganDetailArr = [[NewKTDetail sharedInstance]fetchKTByYear:self.currentYear andDate:self.currentData andGan:self.currentGan];
            NSInteger num     = self.ganDetailArr.count;
            for (NSInteger i = 0; i < num; i ++) {
                NewKTDetailModel *model = self.ganDetailArr[i];
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(model.orignX, model.orignY, model.frameWidth, model.frameHeight)];
                if (model.frameWidth > 15) {
                    imageV.contentMode = UIViewContentModeScaleAspectFit;
                }else{
                    imageV.contentMode = UIViewContentModeScaleToFill;
                }
                imageV.userInteractionEnabled = YES;
                imageV.image = model.image;
                imageV.UUTag = model.Tag;
                [self addTmpViewGesture:imageV];
                [_ganView addSubview:imageV];
            }
        //}
    }
    return _ganView;
}
#pragma mark - 增加衣架

#pragma mark - 增加上面的视图
-(void)addButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 45, 44);
    [backButton setImage:[[UIImage imageNamed:@"return001"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(0, 0, 45, 44);
    [doneButton setImage:[[UIImage imageNamed:@"baocun001"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:doneButton];
    
//    UIButton *deleButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    deleButton.frame = CGRectMake(0, 0, 45, 44);
//    [deleButton setImage:[[UIImage imageNamed:@"delete001"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
//    [deleButton addTarget:self action:@selector(deletes:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithCustomView:deleButton];
    
    self.navigationItem.leftBarButtonItems = @[item1,item2];
    
    UIButton *goodsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    goodsButton.backgroundColor = [UIColor redColor];
    [goodsButton setBackgroundImage:[UIImage imageNamed:@"pinlei001"] forState:UIControlStateNormal];
//    goodsButton.tintColor = [UIColor clearColor];
    //goodsButton.showsTouchWhenHighlighted = NO;
    [goodsButton addTarget:self action:@selector(goods:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc]initWithCustomView:goodsButton];
    
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    timeButton.frame = CGRectMake(0, 0, 45, 44);
    [timeButton setImage:[[UIImage imageNamed:@"pinlei001"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    timeButton.tintColor = [UIColor clearColor];
    timeButton.showsTouchWhenHighlighted = NO;
    [timeButton addTarget:self action:@selector(goods:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item5 = [[UIBarButtonItem alloc]initWithCustomView:timeButton];
    
    self.navigationItem.rightBarButtonItems = @[item4,item5];
}
//返回
-(void)back:(UIButton *)button{
    if (self.haveChanged) {
        self.fanHuiBool = YES;
        [self editOrNo];
        if (self.handler) {
            self.handler(@"YES");
        }
    }else if (self.panDuanBool) {
        [self editHuoPin];
        if (self.handler) {
            self.handler(@"YES");
        }
    } else{
        if (self.handler) {
            self.handler(@"YES");
        }
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBar.barTintColor = nil;
    }
    
}
//保存
-(void)done:(UIButton *)button{
    
    if (self.haveChanged) {
        ZhuTiModel *model = [[ZhuTiDB sharedInstance]fetchKTByYear:self.currentYear andDate:self.currentData andDetail:self.currentGan];
        [[ZhuTiDB sharedInstance]deleteByTag:model.tag];
        [[ZhuTiDB sharedInstance]addDetailModel:[self jietu]];
        self.haveChanged = NO;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已保存！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:alert repeats:NO];
    }
    if (self.panDuanBool) {
        NSLog(@"裤子");
        [self baoCunScroll];
        [self baoCunXiaZhang];
    }
    
}
- (void)baoCunScroll{
    self.panDuanBool = NO;
    ScrollModel *model = [[ScrollDB sharedInstance] fetchByYear:self.currentYear andDate:self.currentData  andType:@"shangyi"];
    [[ScrollDB sharedInstance]deleteByTag:model.tag];
    [[ScrollDB sharedInstance]addDetailModel:[self scroll]];
}
//xia装
- (void)baoCunXiaZhang {
    self.panDuanBool = NO;
    ScrollModel *model = [[ScrollDB sharedInstance] fetchByYear:self.currentYear andDate:self.currentData andType:@"xiazhuang"];
    [[ScrollDB sharedInstance]deleteByTag:model.tag];
    [[ScrollDB sharedInstance]addDetailModel:[self scrollXiaZhuang]];
}
-(ZhuTiModel *)jietu {
    ZhuTiModel *model = [[ZhuTiModel alloc]init];
    UIGraphicsBeginImageContext(self.ganView.bounds.size);
    [_ganView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewBeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    model.image  = viewBeImage;
    model.year   = self.currentYear;
    model.detail = self.currentGan;
    model.date   = self.currentData;
    model.tag    = [self currentTimer];
    return model;
}
//scroll截图
-(ScrollModel *)scroll {
    ScrollModel *model = [[ScrollModel alloc]init];
    UIImage *jietu     = [self captureScrollView:_ganCollectionView];
    model.image = jietu;
    model.year  = self.currentYear;
    model.date  = self.currentData;
    model.tag   = [self currentTimer];
    model.type  = @"shangyi";
    return model;
}
//scroll截图
-(ScrollModel *)scrollXiaZhuang {
    ScrollModel *model = [[ScrollModel alloc]init];
    UIImage *jietu     = [self captureScrollView:_kuZiCollection];
    model.image = jietu;
    model.year  = self.currentYear;
    model.date  = self.currentData;
    model.tag   = [self currentTimer];
    model.type  = @"xiazhuang";
    return model;
}
//截图ScrollView
- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame        = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame         = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}
-(void)timer:(NSTimer *)timer{
    UIAlertController *alert = timer.userInfo;
    [self dismissViewControllerAnimated:alert completion:nil];
    [timer invalidate];
}
//删除
-(void)deletes:(UIButton *)button{
   
    [[NewKTDetail sharedInstance]deleteByTag:self.changeView.UUTag];
    [self.changeView removeFromSuperview];
    
}
#pragma mark -菜单

//货品
-(void)goods:(UIButton *)button{
    [self addTableMenuView];
    self.tableMenuView.hidden = NO;
    self.goBackView.hidden    = NO;
}
//上货周期
-(void)times:(UIButton *)button{
}
- (void)xuanZeZhuTi {
    //子视图控制器
    if (!self.isEdit) {
        if (self.childViewControllers.count == 0) {
            [self addChildViewController:self.chooseController];
            [self.view addSubview:_chooseController.view];
            
           // self.turnToAddGan = YES;
            
            NSString *year   = [_userDeft objectForKey:@"selectSTR"];
            NSString *string = [NSString stringWithFormat:@"%@%@",year,self.currentData];
            self.yearAndDate = string;
        }
    }
    else {
        
    }
}

#pragma mark - 杆的collection
- (void)createGanCollection {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(120, 150);
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.minimumInteritemSpacing = 0;
    layOut.minimumLineSpacing = 0;
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.ganCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 150.1) collectionViewLayout:layOut];
    _ganCollectionView.backgroundColor = [UIColor whiteColor];
    _ganCollectionView.delegate = self;
    _ganCollectionView.dataSource = self;
    _ganCollectionView.showsHorizontalScrollIndicator = NO;
    _ganCollectionView.showsVerticalScrollIndicator = NO;
    [_ganCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ganCellID"];
    [self.view addSubview:_ganCollectionView];
}

-(void)createData{
    if (self.yearAndDate == nil) {
    
    }else {
        NSArray *arr = [_userDeft objectForKey:self.yearAndDate];
        self.toolArr = [NSMutableArray arrayWithArray:arr];
        
        self.ganArray = [[NewKTDB sharedInstance]fetchKTBySession:self.currentYear andDate:self.currentData];
        self.kuZiArray = [[KuZiDB sharedInstance] fetchKTBySession:self.currentYear andDate:self.currentData];
    }
}

#pragma mark - collection类型的返回按钮
-(void)tgo{
    self.detailHeadView.hidden = YES;
    self.collectionMenuView.hidden = YES;
}

#pragma mark - collectionView 的视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   if (collectionView == self.collectionMenuView) {
        return self.detailArray.count;
    }
    else if (collectionView == self.ganCollectionView){
        return self.ganArray.count;
        
    }
    else if (collectionView == self.boDuanCollection){
        return 6;
    } else if (collectionView == self.kuZiCollection){
        return self.kuZiArray.count;
    } else {
        return 0;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.kuZiCollection) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kuZiCellID" forIndexPath:indexPath];
        UIImageView *imageView = [[UIImageView alloc] init];
        KuZiModel *model = self.kuZiArray[indexPath.row];
        imageView.image = model.image;
        imageView.UUTag = model.detailTag;
        imageView.layer.borderWidth = 1.0;
        imageView.userInteractionEnabled = YES;
        imageView.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.backgroundView = imageView;
        
        UIImageView *markView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        markView.image = [UIImage imageNamed:@"xiaosanjiao.png"];
        [cell.backgroundView addSubview:markView];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, 20, 20)];
        numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        numLabel.font = [UIFont systemFontOfSize:12];
        if (indexPath.row>100) {
            numLabel.font = [UIFont systemFontOfSize:10];
        }
        numLabel.textColor = [UIColor darkGrayColor];
        
        [cell.backgroundView addSubview:numLabel];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick1:)];
        [cell addGestureRecognizer:longPress];
        // 向上滑
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [cell addGestureRecognizer:swipeUp];
        
        return cell;
    }
    if (collectionView == self.boDuanCollection) {
             BoduanViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"boDuanCellID" forIndexPath:indexPath];
        //NSArray *arr = [NSArray arrayWithObjects:@"第一杆",@"第二杆", @"第三杆", @"第四杆", @"第五杆", @"第六杆",  nil];
//        UILabel *label = [[UILabel alloc] init];
//        label.text = _arr[indexPath.row];
//        label.textColor = [UIColor whiteColor];
//        label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.layer.borderWidth = 1;
//        label.userInteractionEnabled = YES;
//         label.layer.borderColor = [UIColor colorWithRed:135.0/256 green:135.0/256 blue:135.0/256 alpha:1.0].CGColor;
//        
//        cell.backgroundView = label;
        cell.boDuanLabel.text = _arr[indexPath.row];
        return cell;
    }
    if (collectionView == self.ganCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ganCellID" forIndexPath:indexPath];
       // GanModel *model = self.ganArray[indexPath.row];
        UIImageView *imageView = [[UIImageView alloc] init];
        NewKTModel *model = self.ganArray[indexPath.row];
        imageView.image = model.image;
        imageView.UUTag = model.detailTag;
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.backgroundView = imageView;
        
        UIImageView *markView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        markView.image = [UIImage imageNamed:@"xiaosanjiao.png"];
        [cell.backgroundView addSubview:markView];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, 20, 20)];
        numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        numLabel.font = [UIFont systemFontOfSize:12];
        if (indexPath.row>100) {
            numLabel.font = [UIFont systemFontOfSize:10];
        }
        numLabel.textColor = [UIColor darkGrayColor];
        
        [cell.backgroundView addSubview:numLabel];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
        [cell addGestureRecognizer:longPress];
        // 向上滑
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp1:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [cell addGestureRecognizer:swipeUp];
        
        return cell;
    }
    if (collectionView == self.collectionMenuView) {
        if (self.yiJaiBOOL) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
            cell.layer.borderWidth = 1.0;
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = self.detailArray[indexPath.row];
            cell.backgroundView = imageView;
            return cell;
        } else {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
            cell.layer.borderWidth = 1.0;
            cell.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
            ClothPhoto *cloth = self.detailArray[indexPath.row];
            //cell上的按钮
            UIButton *frontButton = [UIButton buttonWithType:UIButtonTypeSystem];
            frontButton.frame = CGRectMake(0, 140, 90, 40);
            [frontButton setTitle:@"正面" forState:UIControlStateNormal];
            frontButton.tag = 3333+indexPath.row;
            [frontButton setTitleColor:[UIColor colorWithRed:72.0/255 green:200.0/255 blue:90.0/255 alpha:1.0] forState:UIControlStateNormal];
            frontButton.backgroundColor = [UIColor colorWithRed:251.0/255 green:251.0/255 blue:251.0/255 alpha:1.0];
            [frontButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [frontButton addTarget:self action:@selector(fontClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeSystem];
            profileButton.frame = CGRectMake(90, 140, 90, 40);
            [profileButton setTitle:@"侧面" forState:UIControlStateNormal];
            profileButton.tag = 4444+indexPath.row;
            profileButton.backgroundColor = [UIColor colorWithRed:251.0/255 green:251.0/255 blue:251.0/255 alpha:1.0];
            [profileButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            if (cloth.backImage == nil) {
                [profileButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }else{
                [profileButton setTitleColor:[UIColor colorWithRed:72.0/255 green:200.0/255 blue:90.0/255 alpha:1.0] forState:UIControlStateNormal];
                [profileButton addTarget:self action:@selector(profileClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell addSubview:frontButton];
            [cell addSubview:profileButton];
            
            UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
            photoView.contentMode = UIViewContentModeScaleAspectFit;
            photoView.backgroundColor = [UIColor whiteColor];
            if (indexPath.row == (self.currentTag-4444)) {
                photoView.image = cloth.backImage;
            }else{
                photoView.image = cloth.image;
            }
            cell.backgroundView = photoView;
            
            return cell;
        }
    }
    return nil;
}
//正面按钮
-(void)fontClick:(UIButton *)button{
    self.currentTag = button.tag;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:button.tag-3333 inSection:0];
    [self.collectionMenuView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
}
//侧面按钮
-(void)profileClick:(UIButton *)button{
    self.currentTag = button.tag;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:button.tag-4444 inSection:0];
    [self.collectionMenuView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
}
#pragma mark - 上华删除的事件裤子
- (void)swipeUp:(UIGestureRecognizer *)swipe {
    self.panDuanBool = YES;
    UICollectionViewCell *cell = (UICollectionViewCell *)swipe.view;
    UIImageView *imageView = (UIImageView *)cell.backgroundView;
    CGPoint center = imageView.center;
    imageView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = CGRectMake(center.x, 0, 0, 0);
    } completion:^(BOOL finished) {
        [[KuZiDB sharedInstance] deleteBySession:imageView.UUTag];
        
        [self createData];
        [self.kuZiCollection reloadData];
    }];
}
//上衣的删除事件
- (void)swipeUp1:(UIGestureRecognizer *)swipe {
    self.panDuanBool = YES;
    UICollectionViewCell *cell = (UICollectionViewCell *)swipe.view;
    UIImageView *imageView = (UIImageView *)cell.backgroundView;
    CGPoint center = imageView.center;
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = CGRectMake(center.x, 0, 0, 0);
    } completion:^(BOOL finished) {
        [[NewKTDB sharedInstance] deleteBySession:imageView.UUTag];
        [self createData];
        [self.ganCollectionView reloadData];
    }];
}

#pragma mark -拖动手势
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (collectionView == self.ganCollectionView) {
        return YES;
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.ganCollectionView) {
        return YES;
    }
    return NO;
}
- (void)longPressClick1:(UILongPressGestureRecognizer *)longPress{
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.kuZiCollection];
    NSLog(@"%f %f",location.x,location.y);
    NSIndexPath *indexPath = [self.kuZiCollection indexPathForItemAtPoint:location];
    
    NSLog(@"%@",indexPath);
    static UIView *snapshot = nil;//把长按的cell加载到snapshot上
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if(indexPath){
                sourceIndexPath = indexPath;
                UICollectionViewCell *cell = [self.kuZiCollection cellForItemAtIndexPath:indexPath];
                snapshot = [self customSnapshothotFromeView:cell];//快照
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.kuZiCollection addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05,1.05);
                    snapshot.alpha = 0.98;
                    cell.hidden = YES;//长按是把当前的cell影藏掉
                }completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint center = snapshot.center;
            center.y = location.y;
            center.x = location.x;
            snapshot.center = center;
            if(indexPath && ![indexPath isEqual:sourceIndexPath]){
                [self.kuZiArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row ];
                
                [self.kuZiCollection moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath =indexPath;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            
        }
        default:
        {
            UICollectionViewCell *cell =[self.kuZiCollection cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
            }completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                cell.hidden = NO;
                snapshot = nil;
            }];
            [self.kuZiCollection reloadData];
            sourceIndexPath = nil;
        }
            break;
    }
}
- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.ganCollectionView];
    NSLog(@"%f %f",location.x,location.y);
    NSIndexPath *indexPath = [self.ganCollectionView indexPathForItemAtPoint:location];
    
    NSLog(@"%@",indexPath);
    static UIView *snapshot = nil;//把长按的cell加载到snapshot上
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if(indexPath){
                sourceIndexPath = indexPath;
                UICollectionViewCell *cell = [self.ganCollectionView cellForItemAtIndexPath:indexPath];
                snapshot = [self customSnapshothotFromeView:cell];//快照
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.ganCollectionView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05,1.05);
                    snapshot.alpha = 0.98;
                    cell.hidden = YES;//长按是把当前的cell影藏掉
                }completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint center = snapshot.center;
            center.y = location.y;
            center.x = location.x;
            snapshot.center = center;
            if(indexPath && ![indexPath isEqual:sourceIndexPath]){
                [self.ganArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row ];
                
                [self.ganCollectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath =indexPath;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            
        }
        default:
        {
            UICollectionViewCell *cell =[self.ganCollectionView cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
            }completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                cell.hidden = NO;
                snapshot = nil;
            }];
            [self.ganCollectionView reloadData];
            sourceIndexPath = nil;
        }
            break;
    }
}
- (UIView *)customSnapshothotFromeView:(UIView *)inputView{
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

#pragma mark - 菜单单栏
//添加菜单栏
-(void)addTableMenuView{
    self.goBackView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-200, 0, 200, 50)];
   // _goBackView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    _goBackView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    _goBackView.hidden = YES;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(-80, 0, 220, 40);
   // back.backgroundColor = [UIColor redColor];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0] forState:UIControlStateNormal];
    [back.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [back addTarget:self action:@selector(gogo) forControlEvents:UIControlEventTouchUpInside];
    [_goBackView addSubview:back];
    [self.view addSubview:_goBackView];
    
    self.viewFrame = CGRectMake(kWidth-200, 45, 200, kHeight);
    self.tableMenuView = [[UITableView alloc]initWithFrame:_viewFrame style:UITableViewStylePlain];
    _tableMenuView.hidden = YES;
    _tableMenuView.delegate = self;
    _tableMenuView.dataSource = self;
    //_tableMenuView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    _tableMenuView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    _tableMenuView.separatorColor = [UIColor lightGrayColor];
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    _tableMenuView.tableFooterView = footView;
    [self.view addSubview:_tableMenuView];
    self.currentTag = 0;
}
-(void)gogo{
    self.goBackView.hidden = YES;
    self.tableMenuView.hidden = YES;
}
#pragma mark - 中文提示当修改的时候 所有货品的截图保存
- (void)editHuoPin {//所有货品的截图保存
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请你选择是否保存修改！" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *baoCun = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self baoCunScroll];
        [self baoCunXiaZhang];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIAlertAction *buBaoCun = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.panDuanBool = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:baoCun];
    [alert addAction:buBaoCun];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)editOrNo {
    if (self.haveChanged) {
         [self baoCunJieTu];
        if (_fanHuiBool) {
            if (self.panDuanBool) {
                [self editHuoPin];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
- (void)baoCunJieTu {
    ZhuTiModel *model = [[ZhuTiDB sharedInstance]fetchKTByYear:self.currentYear andDate:self.currentData andDetail:self.currentGan];
    [[ZhuTiDB sharedInstance]deleteByTag:model.tag];
    [[ZhuTiDB sharedInstance]addDetailModel:[self jietu]];
    self.haveChanged = NO;
}
#pragma mark -collection联动

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _ganCollectionView) { // 如果滚动左侧，让右侧保持一致
        _kuZiCollection.contentOffset = _ganCollectionView.contentOffset;
    } else { // 如果滚动右侧，让左侧保持一致
        _ganCollectionView.contentOffset = _kuZiCollection.contentOffset;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.kuZiCollection) {
        self.haveChanged = YES;
        if (self.isEdit) {
            if(self.ganDetailArr.count == 0) {
                UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+_pidWidth++ *64.7, 124, 60, 95)];
                if (_pidWidth > 13) {
                    _pidWidth = 0.0;
                }
                self.changeView = tmpImageView;
                tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
                KuZiModel *model = self.kuZiArray[indexPath.row];
                tmpImageView.image = model.image;
                [_ganView addSubview:tmpImageView];
                tmpImageView.userInteractionEnabled = YES;
                tmpImageView.UUTag = [self currentTimer];
                [self addTmpViewGesture:tmpImageView];
            } else {
                CGFloat resultWidth = arc4random()%100*3;
                UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50+resultWidth, 124, 60, 95)];
                self.changeView = tmpImageView;
                tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
                KuZiModel *model = self.kuZiArray[indexPath.row];
                tmpImageView.image = model.image;
                [_ganView addSubview:tmpImageView];
                tmpImageView.userInteractionEnabled = YES;
                tmpImageView.UUTag = [self currentTimer];
                [self addTmpViewGesture:tmpImageView];
            }
        }else {
            UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+_pidWidth++ *64.7, 124, 60, 95)];
            if (_pidWidth > 13) {
                _pidWidth = 0.0;
            }
            self.changeView = tmpImageView;
            tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
            KuZiModel *model = self.kuZiArray[indexPath.row];
            tmpImageView.image = model.image;
            [_ganView addSubview:tmpImageView];
            tmpImageView.userInteractionEnabled = YES;
            tmpImageView.UUTag = [self currentTimer] ;
            [self addTmpViewGesture:tmpImageView];
        }
        [[NewKTDetail sharedInstance]addDetailModel:[self currentGanHuo]];
    }
    //波段的点击事件
    if (collectionView == self.boDuanCollection) {
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        BoduanViewCell *selectCell = (BoduanViewCell *)[_boDuanCollection cellForItemAtIndexPath:selectedIndexPath];
        selectCell.boDuanLabel.textColor = [UIColor whiteColor];
        selectCell.boDuanLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
            BoduanViewCell *cell = (BoduanViewCell *)[self.boDuanCollection cellForItemAtIndexPath:indexPath];
            //NSArray *arr = [NSArray arrayWithObjects:@"第一杆",@"第二杆", @"第三杆", @"第四杆", @"第五杆", @"第六杆",  nil];
//            UILabel *label = [[UILabel alloc] init];
//            label.text = _arr[indexPath.row];
//            label.textColor = [UIColor greenColor];
//            label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.layer.borderWidth = 1;
//            label.layer.borderColor = [UIColor colorWithRed:135.0/256 green:135.0/256 blue:135.0/256 alpha:1.0].CGColor;
//            
//            cell.backgroundView = label;
        
            cell.boDuanLabel.textColor = [UIColor greenColor];
            cell.boDuanLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        if (indexPath.row == 0) {
            [self editOrNo];
            self.pidWidth = 0;
            self.pidWidth1 = 0;
            self.currentGan = nil;
            self.currentGan = @"第一杆";
            [_ganView removeFromSuperview];
            _ganView = nil;
            if (_ganView == nil) {
                [self.view addSubview:self.ganView];
            }
        } else if (indexPath.row == 1) {
             [self editOrNo];
            self.pidWidth = 0;
            self.pidWidth1 = 0;
            self.currentGan = nil;
            self.currentGan = @"第二杆";
            [_ganView removeFromSuperview];
            _ganView = nil;
            if (_ganView == nil) {
                [self.view addSubview:self.ganView];
            }
        } else if (indexPath.row == 2) {
            [self editOrNo];
            self.pidWidth = 0;
            self.pidWidth1 = 0;
            self.currentGan = nil;
            self.currentGan = @"第三杆";
            [_ganView removeFromSuperview];
            _ganView = nil;
            if (_ganView == nil) {
                [self.view addSubview:self.ganView];
            }
        } else if (indexPath.row == 3) {
             [self editOrNo];
            self.pidWidth = 0;
            self.pidWidth1 = 0;
            self.currentGan = nil;
            self.currentGan = @"第四杆";
            [_ganView removeFromSuperview];
            _ganView = nil;
            if (_ganView == nil) {
                [self.view addSubview:self.ganView];
            }
        } else if (indexPath.row == 4) {
            [self editOrNo];
            self.pidWidth = 0;
            self.pidWidth1 = 0;
            self.currentGan = nil;
            self.currentGan = @"第五杆";
            [_ganView removeFromSuperview];
            _ganView = nil;
            if (_ganView == nil) {
                [self.view addSubview:self.ganView];
            }
        } else {
            [self editOrNo];
            self.pidWidth = 0;
            self.pidWidth1 = 0;
            self.currentGan = nil;
            self.currentGan = @"第六杆";
            [_ganView removeFromSuperview];
            _ganView = nil;
            if (_ganView == nil) {
                [self.view addSubview:self.ganView];
            }
        }
    }
    if (collectionView == self.ganCollectionView) {
        self.haveChanged = YES;
        if (self.isEdit) {
            if (self.ganDetailArr.count == 0) {
                UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+_pidWidth1++ *64.7, 43, 60, 85)];
                if (_pidWidth1 > 13) {
                    _pidWidth1 = 0.0;
                }
                self.changeView = tmpImageView;
                tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
                NewKTModel *model = self.ganArray[indexPath.row];
                tmpImageView.image = model.image;
                [_ganView addSubview:tmpImageView];
                tmpImageView.userInteractionEnabled = YES;
                tmpImageView.UUTag = [self currentTimer];
                [self addTmpViewGesture:tmpImageView];
            } else {
                CGFloat resultWidth = arc4random()%100*3;
                UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50+resultWidth, 50, 60, 85)];
                self.changeView = tmpImageView;
                tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
                NewKTModel *model = self.ganArray[indexPath.row];
                tmpImageView.image = model.image;
                [_ganView addSubview:tmpImageView];
                tmpImageView.userInteractionEnabled = YES;
                tmpImageView.UUTag = [self currentTimer];
                [self addTmpViewGesture:tmpImageView];
            }
        } else {
            UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+_pidWidth1++ *64.7, 43, 60, 85)];
            if (_pidWidth1 > 13) {
                _pidWidth1 = 0.0;
            }
            self.changeView = tmpImageView;
            tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
            NewKTModel *model = self.ganArray[indexPath.row];
            tmpImageView.image = model.image;
            [_ganView addSubview:tmpImageView];
            tmpImageView.userInteractionEnabled = YES;
            tmpImageView.UUTag = [self currentTimer];
            [self addTmpViewGesture:tmpImageView];
        }
        [[NewKTDetail sharedInstance]addDetailModel:[self currentGanHuo]];
    }
    if (collectionView ==self.collectionMenuView) {
            if (self.yiJaiBOOL) {
                self.haveChanged = YES;
                UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(37+_pidWidth2++ *75, 0, 20, 100)];
                if (_pidWidth2 > 11) {
                    _pidWidth2 = 0.5;
                }
                tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
                self.changeView = tmpImageView;
                tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
                
                tmpImageView.image = self.detailArray[indexPath.row];
                [_ganView addSubview:tmpImageView];
                tmpImageView.userInteractionEnabled = YES;
                tmpImageView.UUTag = [self currentTimer];
                [self addTmpViewGesture:tmpImageView];
                [[NewKTDetail sharedInstance]addDetailModel:[self currentGanHuo]];
            } else {
                if ( indexPath.row == (self.currentTag-4444)) {
                    ClothPhoto *cloth = self.detailArray[indexPath.row];
                    self.changeImage = cloth.backImage;
                    self.haveChanged = YES;
                    CGFloat resultWidth = arc4random()%100*3;
                    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(resultWidth, 50, 20, 100)];
                    tmpImageView.image = self.changeImage;
                    tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
                    [_ganView addSubview:tmpImageView];
                    tmpImageView.userInteractionEnabled = YES;
                   // tmpImageView.tag = [[self currentTimer] longLongValue];
                    self.changeView = tmpImageView;
                    [self addTmpViewGesture:tmpImageView];
                    [[NewKTDetail sharedInstance]addDetailModel:[self currentGanHuo1]];
                } else {
                    if (self.kuZiBool) {
                        self.panDuanBool = YES;
                        ClothPhoto *cloth = self.detailArray[indexPath.row];
                        [self createCoreAnimation:(UIImage *)cloth.image];
                        self.changeImage = cloth.image;
                        [[KuZiDB sharedInstance]addDetailModel:[self kuZiModel]];
                        [self.kuZiArray addObject:[self kuZiModel]];
                        [self.kuZiCollection reloadData];
                    } else {
                         self.panDuanBool = YES;
                        ClothPhoto *cloth = self.detailArray[indexPath.row];
                        [self createCoreAnimation:(UIImage *)cloth.image];
                        self.changeImage = cloth.image;
                        [[NewKTDB sharedInstance]addDetailModel:[self newKTModel]];
                        [self.ganArray addObject:[self newKTModel]];
                        [self.ganCollectionView reloadData];
                    }
                }
            }
    }
}

#pragma mark - createCoreAnimation 动画
- (void)createCoreAnimation:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(380, 280, 120, 120)];
    //imageView.center = self.view.center;
    imageView.image = image;
    //imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.contentMode =  UIViewContentModeScaleAspectFit;
    imageView.layer.cornerRadius = 60;
    [self.view addSubview:imageView];
    
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform0 = CATransform3DRotate(imageView.layer.transform,0,0,0,1); // 0度
    CATransform3D transform1 = CATransform3DRotate(imageView.layer.transform,M_PI_2,0,0,1); // 90度
    CATransform3D transform2 = CATransform3DRotate(imageView.layer.transform,M_PI,0,0,1); // 180度
    CATransform3D transform3 = CATransform3DRotate(imageView.layer.transform,3.0/2*M_PI,0,0,1); // 270度
    CATransform3D transform4 = CATransform3DRotate(imageView.layer.transform,2*M_PI,0,0,1); // 360度
    keyFrame.values = @[
                        [NSValue valueWithCATransform3D:transform0],
                        [NSValue valueWithCATransform3D:transform1],
                        [NSValue valueWithCATransform3D:transform2],
                        [NSValue valueWithCATransform3D:transform3],
                        [NSValue valueWithCATransform3D:transform4],
                        ]; // 关键帧动画 取值范围
    
    keyFrame.duration = 0.5; // 整个动画耗时5秒
    keyFrame.repeatCount = HUGE_VAL; // 为了让动画一直进行，一直重复
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; // 动画时间曲线 kCAMediaTimingFunctionLinear 线性变换 平缓
    keyFrame.keyTimes = @[@(0.0),@(0.25),@(0.5),@(0.75),@(1.0)]; // 变换取值点
    [imageView.layer addAnimation:keyFrame forKey:@"playMusic"];
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = CGRectMake(430, 330,10, 10);
    } completion:^(BOOL finished) {
        imageView.alpha = 0.0;
        [imageView removeFromSuperview];
    }];
    
}
#pragma mark - collection 的取消的点击事件
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.boDuanCollection) {
        BoduanViewCell *cell = (BoduanViewCell *)[self.boDuanCollection cellForItemAtIndexPath:indexPath];
        //NSArray *arr = [NSArray arrayWithObjects:@"第一杆",@"第二杆", @"第三杆", @"第四杆", @"第五杆", @"第六杆",  nil];
//        UILabel *label = [[UILabel alloc] init];
//        label.text = arr[indexPath.row];
//        label.textColor = [UIColor whiteColor];
//        label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.layer.borderWidth = 1;
//        label.userInteractionEnabled = YES;
//        label.layer.borderColor = [UIColor colorWithRed:135.0/256 green:135.0/256 blue:135.0/256 alpha:1.0].CGColor;
//        cell.backgroundView = label;

        cell.boDuanLabel.textColor = [UIColor whiteColor];
        cell.boDuanLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
}
#pragma mark -tableView 的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    cell.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    cell.textLabel.text = self.dataArray[indexPath.row];
//    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed:@"last"] forState:UIControlStateNormal];
    cell.accessoryView = button;
    return cell;
}
//点击类型就返回相应地数据
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"衣架"]) {
        self.detailArray = nil;
//        UIImage *image = [UIImage imageNamed:@"kujia.png"];
//        UIImage *image1 = [UIImage imageNamed:@"yijia1.png"];
//        //UIImage *ceGuaImage = [UIImage imageNamed:@"cegua1.png"];
//        [self.detailArray addObject:image];
//        [self.detailArray addObject:image1];
        //[self.detailArray addObject:ceGuaImage];
        self.yiJaiBOOL = YES;
    } else {
        self.yiJaiBOOL = NO;
    }
    if ([cell.textLabel.text isEqualToString:@"裤子"]||indexPath.row == 1||[cell.textLabel.text isEqualToString:@"下装"]) {
        self.kuZiBool = YES;
    } else {
        self.kuZiBool = NO;
    }
    self.didSelectType = self.dataArray[indexPath.row];
    [self createDetailData];
    [self addCollectionDetail];
    
    
}
//详细的数据
-(void)createDetailData{
    NSString *yearString = [_userDeft objectForKey:@"selectSTR"];
    if (!self.yiJaiBOOL) {
        self.detailArray = [[DataBase shareInstance]fetchBySession:yearString andType:_didSelectType];
    }
    
}
//添加详细品类
-(void)addCollectionDetail{
    self.detailHeadView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-200, 0, 200, 45)];
    //_detailHeadView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    _detailHeadView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(10, 10, 25, 25);
    [back setBackgroundImage:[UIImage imageNamed:@"return001"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(tgo) forControlEvents:UIControlEventTouchUpInside];
    [_detailHeadView addSubview:back];
    self.detailMidLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 40)];
    _detailMidLable.text = self.didSelectType;
    //_detailMidLable.textColor = [UIColor whiteColor];
    _detailMidLable.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    _detailMidLable.textAlignment = NSTextAlignmentCenter;
    _detailMidLable.font = [UIFont systemFontOfSize:20];
    [_detailHeadView addSubview:_detailMidLable];
    [self.view addSubview:_detailHeadView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(180, 180);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    CGRect rect = self.viewFrame;
    rect.size.height = _viewFrame.size.height - 120;
    self.collectionMenuView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
    _collectionMenuView.delegate = self;
    _collectionMenuView.dataSource = self;
    _collectionMenuView.showsVerticalScrollIndicator = NO;
    //_collectionMenuView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    _collectionMenuView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    //注册cell
    [_collectionMenuView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionMenuView];
}
-(void)addTmpViewGesture:(UIImageView *)tmp{
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(tmpPin:)];
    [tmp addGestureRecognizer:pin];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panResult:)];
    [tmp addGestureRecognizer:panGesture];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];//点击成为第一响应者
    [tmp addGestureRecognizer:tap];
}
- (void)panResult:(UIPanGestureRecognizer *)pan1 {
    self.haveChanged = YES;
    self.changeView.layer.borderWidth = 0;
    UIImageView *currentView = (UIImageView *)pan1.view;
    self.changeView = currentView;
    CGPoint point = [pan1 translationInView:self.ganView];
    CGPoint center = currentView.center;
    center.x += point.x;
    center.y += point.y;
    
    if (center.x <= currentView.frame.size.width/2.0) {
        center.x = currentView.frame.size.width/2.0;
    }else if (center.x >= self.ganView.frame.size.width - currentView.frame.size.width/2.0){
        center.x = self.ganView.frame.size.width - currentView.frame.size.width/2.0;
    }
    if (center.y <= currentView.frame.size.height/2.0) {
        center.y = currentView.frame.size.height/2.0;
    }else if (center.y >= self.ganView.frame.size.height - currentView.frame.size.height/2.0){
        center.y = self.ganView.frame.size.height - currentView.frame.size.height/2.0;
    }
    currentView.center = center;
    //  不让它累加
    [pan1 setTranslation:CGPointZero inView:_ganView];
    if (pan1.state == UIGestureRecognizerStateEnded) {
        [[NewKTDetail sharedInstance]update:[self currentGanHuo]];
    }
}

#pragma mark -放大缩小
- (void)tmpPin:(UIPinchGestureRecognizer *)pinch {
    self.haveChanged = YES;
    self.changeView.layer.borderWidth = 0;
    UIImageView *iamgeView = (UIImageView *)pinch.view;
    self.changeView = iamgeView;
    iamgeView.transform = CGAffineTransformScale(iamgeView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0;
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [[NewKTDetail sharedInstance]update:[self currentGanHuo]];
    }
}
#pragma mark - 点击成为第一响应者
- (void)tapGesture:(UITapGestureRecognizer *)tap {
    self.haveChanged = YES;
    self.changeView.layer.borderWidth = 0;
    UIImageView *currentView = (UIImageView *)tap.view;
    CGRect currentRect = currentView.frame;
    NSString *CUTAG = currentView.UUTag;
    self.changeView = currentView;
    currentView.layer.borderWidth = 2.0;
    currentView.layer.borderColor = kBordColor;
    [_ganView bringSubviewToFront:currentView];
    
#pragma mark - 弹出POP控制器
    //弹出POP
    MenuPopController *menuPOPController = [[MenuPopController alloc]init];
    if (self.changeView.frame.size.width >=15) {
        menuPOPController.dataArray = [NSArray arrayWithObjects:@"删除",@"侧挂",@"换色",@"廓形", nil];
    }else{
        menuPOPController.dataArray = [NSArray arrayWithObjects:@"删除",@"正挂",@"换色",@"廓形", nil];
    }
    [menuPOPController setSelectHandler:^(NSString *string) {
        NSLog(@"POP----block---%@",string);
        if ([string isEqualToString:@"删除"]) {
            [[NewKTDetail sharedInstance]deleteByTag:self.changeView.UUTag];
            [self.changeView removeFromSuperview];
        }else if ([string isEqualToString:@"侧挂"]){
            self.changeView.contentMode = UIViewContentModeScaleToFill;
            CGPoint center = self.changeView.center;
            self.changeView.frame = CGRectMake(self.changeView.frame.origin.x, self.changeView.frame.origin.y, 10, self.changeView.frame.size.height);
            self.changeView.center = center;
            [[NewKTDetail sharedInstance]update:[self currentGanHuo]];
        }else if ([string isEqualToString:@"正挂"]){
            self.changeView.contentMode = UIViewContentModeScaleAspectFit;
            CGPoint center = self.changeView.center;
            self.changeView.frame = CGRectMake(self.changeView.frame.origin.x, self.changeView.frame.origin.y, 60, self.changeView.frame.size.height);
            self.changeView.center = center;
            [[NewKTDetail sharedInstance]update:[self currentGanHuo]];
        }else if([string isEqualToString:@"换色"]){
#pragma mark - 跳转到换色界面
            ChangeColorController *changeColorController = [[ChangeColorController alloc]init];
            self.changeView.layer.borderWidth = 0;
            changeColorController.kImageView = self.changeView;
            changeColorController.ysImage = self.changeView.image;
            __weak typeof(self) weakSelf = self;
            [changeColorController setDoneHandler:^(UIImageView *imageView) {
                UIImageView *blockImageV = imageView;
                blockImageV.contentMode = UIViewContentModeScaleAspectFit;
                blockImageV.userInteractionEnabled = YES;
                blockImageV.UUTag = CUTAG;
                [self addTmpViewGesture:blockImageV];
                blockImageV.frame = currentRect;
                [weakSelf.ganView addSubview:blockImageV];
                weakSelf.changeView = blockImageV;
                blockImageV.layer.borderWidth = 2.0;
                blockImageV.layer.borderColor = kBordColor;
                 [weakSelf.ganView bringSubviewToFront:blockImageV];
                [[NewKTDetail sharedInstance]update:[weakSelf currentGanHuo]];
            }];
            [self.navigationController pushViewController:changeColorController animated:YES];
        }else if ([string isEqualToString:@"廓形"]){
            CIContext *context = [CIContext contextWithOptions:nil];
            UIImage *image = self.changeView.image;
            NSData *data = UIImagePNGRepresentation(image);
            CIImage *ciImage = [CIImage imageWithData:data];
            CIFilter *ldFliter = [CIFilter filterWithName:@"CIExposureAdjust"];
            [ldFliter setValue:ciImage forKey:kCIInputImageKey];
            [ldFliter setValue:[NSNumber numberWithFloat:10] forKey:@"inputEV"];
            CIImage *outputImage = [ldFliter outputImage];
            CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
            UIImage *newImg = [UIImage imageWithCGImage:cgimg];
            [self.changeView setImage:newImg];
            self.changeView.backgroundColor = [UIColor grayColor];
            CGImageRelease(cgimg);
        }
    }];
    menuPOPController.modalPresentationStyle = UIModalPresentationPopover;
    menuPOPController.preferredContentSize = CGSizeMake(170, 40);
    UIPopoverPresentationController *popController = menuPOPController.popoverPresentationController;
    popController.sourceView = tap.view;
    popController.sourceRect = tap.view.bounds;
    popController.delegate   = self;
    popController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    [self presentViewController:menuPOPController animated:YES completion:nil];
}

-(NewKTDetailModel *)currentGanHuo{
    NewKTDetailModel *model = [[NewKTDetailModel alloc]init];
    model.orignX            = self.changeView.frame.origin.x;
    model.orignY            = self.changeView.frame.origin.y;
    model.frameWidth        = self.changeView.frame.size.width;
    model.frameHeight       = self.changeView.frame.size.height;
    model.image             = self.changeView.image;
    model.Tag               = self.changeView.UUTag;
    model.currentYear       = [_userDeft objectForKey:@"selectSTR"];
    model.currentDate       = self.currentData;
    model.currentGan        = self.currentGan;
   
    return model;
}
-(NewKTDetailModel *)currentGanHuo1{
    NewKTDetailModel *model = [[NewKTDetailModel alloc]init];
    model.orignX            = self.changeView.frame.origin.x;
    model.orignY            = self.changeView.frame.origin.y;
    model.frameWidth        = self.changeView.frame.size.width;
    model.frameHeight       = self.changeView.frame.size.height;
    model.image             = self.changeView.image;
    model.Tag               = [self currentTimer];
    model.currentYear       = [_userDeft objectForKey:@"selectSTR"];
    model.currentDate       = self.currentData;
    model.currentGan        = self.currentGan;
    
    return model;
}

#pragma mark - 货品数据
-(NewKTModel *)newKTModel{
    NewKTModel *model = [[NewKTModel alloc]init];
    model.image       = self.changeImage;
    model.currentYear = self.currentYear;
    model.currentDate = self.currentData;
    model.detailTag   = [self currentTimer];
    return model;
}
- (KuZiModel *)kuZiModel {
    KuZiModel *model  = [[KuZiModel alloc] init];
    model.image       = self.changeImage;
    model.currentYear = self.currentYear;
    model.currentDate = self.currentData;
    model.detailTag   = [self currentTimer];
    return model;
}
#pragma mark - 取时间tag值
-(NSString *)currentTimer{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSMutableString *str1 = [NSMutableString stringWithString:date];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if (c == ':' || c == '.') {
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", newstr];
    return timeLocal;
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.changeView.layer.borderWidth = 0;
//    [self gogo];
//    [self tgo];
}
- (void)viewDidAppear:(BOOL)animated {
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BoduanViewCell *cell = (BoduanViewCell *)[self.boDuanCollection cellForItemAtIndexPath:selectedIndexPath];
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, 0, 90, 55);
//    label.text = @"第一杆";
    cell.boDuanLabel.textColor = [UIColor greenColor];
    cell.boDuanLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.layer.borderWidth = 1;
//    label.layer.borderColor = [UIColor colorWithRed:135.0/256 green:135.0/256 blue:135.0/256 alpha:1.0].CGColor;
//    [cell addSubview:label];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
