//
//  AddKTController.m
//  好品
//
//  Created by 朱明科 on 15/12/28.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "AddKTController.h"
#import "DataBase.h"
#import "ClothPhoto.h"
#import "KTBodController.h"
#import "KTDBManager.h"
#import "DetailDB.h"
#import "PopContentController.h"

#define kWidth   [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height
#define kBordColor [[UIColor colorWithRed:84.0/255 green:207.0/255 blue:109.0/255 alpha:1.0]CGColor]

@interface AddKTController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate>
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)UICollectionView *detailMenuView;
@property(nonatomic)UITableView *typeMenuView;
@property(nonatomic)UIView *goBackView;
@property(nonatomic)UIView *detailHeadView;
@property(nonatomic)UILabel *detailMidLable;
@property(nonatomic)NSMutableArray *detailDataArr;//array 有哪些衣服
@property(nonatomic)NSMutableArray *typeDataArr;// array 有哪些类型
@property(nonatomic)NSMutableArray *bodsArr;//array 波段数
@property(nonatomic)CGRect viewFrame;//菜单栏的frame
@property(nonatomic,copy)NSString *didSelectType;//记录选中的品类
@property(nonatomic,copy)NSString *didSelectBod;//记录选中的波段
@property(nonatomic,copy)NSString *yearString;//是哪一个年份的
@property(nonatomic)UIView *rootsView;
@property(nonatomic)UIScrollView *scrollView;
@property(nonatomic,copy)NSString *currentStr;//显示选择的波段
@property(nonatomic)NSInteger num;//显示选择的是第几个波段
@property(nonatomic)BOOL isPreserve;//记录是不是已经保存过了
@property(nonatomic)UIImageView *changeView;//正在改变的view
@property(nonatomic)BOOL haveDelorMove;
@property(nonatomic)UIScrollView *superRootView;
@property(nonatomic)UIButton *deleteBtn;
@property(nonatomic)NSMutableArray *tempArray;//存放临时的数据，判断是不是修改过，如果修改过保存的话，删除临时存放数据，如果修改后不保存的话，则将临时修改数据恢复到原先数据库
@property(nonatomic)UIScrollView *lastScrollView;//上一个波段
@property(nonatomic)BOOL turnBod;
@end

@implementation AddKTController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"编辑KT板";
    self.userDeft = [NSUserDefaults standardUserDefaults];
    self.yearString = [_userDeft objectForKey:@"selectSTR"];
    [self addTitleViews];
    [self makeViews];
    [self createMenuData];
    [self createTableMenuView];
    //[self addChildController];
}
//状态栏字体颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
//创建scrollview和title
-(void)makeViews{
    //进行判断如果为空 会creary
    if (self.yearString == nil) {
        return;
    } else {
         self.bodsArr = [NSMutableArray arrayWithArray:[_userDeft objectForKey:self.yearString]];
    }
    self.superRootView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height)];
    self.superRootView.contentSize = CGSizeMake(0, _bodsArr.count*400);
    _superRootView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_superRootView];
    NSInteger count = self.bodsArr.count;
    for (NSInteger i = 0; i < count; i ++) {
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, (50*i+350*i), kWidth-60, 45)];
        titleLable.backgroundColor = [UIColor colorWithRed:239.0/255  green:239.0/255  blue:240.0/255  alpha:1.0];
        titleLable.text = self.bodsArr[i];
        titleLable.font = [UIFont systemFontOfSize:18];
        [self.superRootView addSubview:titleLable];
        UIButton *addbun = [UIButton buttonWithType:UIButtonTypeSystem];
        addbun.tag = 500+i;
        addbun.frame = CGRectMake(kWidth-60, (50*i+350*i), 60, 45);
        addbun.backgroundColor = titleLable.backgroundColor;
        [addbun setTitle:@"编辑" forState:UIControlStateNormal];
        [addbun setTitleColor:[UIColor colorWithRed:62.0/255 green:202.0/255 blue:72.0/255 alpha:1.0] forState:UIControlStateNormal];
        [addbun.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [addbun addTarget:self action:@selector(addBodTitle:) forControlEvents:UIControlEventTouchUpInside];
        [self.superRootView addSubview:addbun];
        
        UIView *rootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth*8, 345)];
        rootView.backgroundColor = [UIColor whiteColor];
        rootView.tag = 100+i;
        [self addOption:rootView andNum:rootView.tag];
        
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50+(350*i+50*i), kWidth, 345)];
        scrollView.contentSize = CGSizeMake(kWidth*8, 0);
        scrollView.bounces = NO;
        scrollView.tag = 200+i;
        scrollView.userInteractionEnabled = NO;//
        //没有选中的波段，让她不能操作
        //
        //
        scrollView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:rootView];
        [self.superRootView addSubview:scrollView];
    }
    if (self.bodsArr.count == 0) {
        self.currentStr = nil;
    }else{
        self.currentStr = self.bodsArr[0];//默认第一个波段
        self.tempArray = [[DetailDB sharedInstance]fetchBySession:self.yearString bod:self.currentStr];
    }
//    self.currentStr = self.bodsArr[0];
    self.num = 0;
    self.rootsView = [self.view viewWithTag:100];
    self.lastScrollView = [self.view viewWithTag:200];
    self.lastScrollView.userInteractionEnabled = YES;
}
//根据tag值添加每个波段的数据
-(void)addOption:(UIView *)currentRootView andNum:(NSInteger)num{
    //按年份波段获取数据
    NSMutableArray *array = [[DetailDB sharedInstance]fetchBySession:_yearString bod:self.bodsArr[num-100]];
    for (NSInteger i = 0; i < array.count; i ++) {
        DetailModel *model = array[i];
        UIImageView *haveImage = [[UIImageView alloc]initWithFrame:CGRectMake(model.orignX,model.orignY, model.frameWidth,model.frameHeight)];
        haveImage.contentMode = UIViewContentModeScaleAspectFit;
        haveImage.image = model.image;
        haveImage.tag = [model.detailTag integerValue];
        haveImage.userInteractionEnabled = YES;
        [self addGesture:haveImage];
        [currentRootView addSubview:haveImage];
    }
}
//波段选择选项
//
//
//
//波段选择子控制器
//
//
//
//
-(void)addBodTitle:(UIButton *)button{
    self.turnBod = self.haveDelorMove == NO ? NO : YES;
    if (self.turnBod == NO) {
        self.num = button.tag - 500;
        self.currentStr = self.bodsArr[_num];
        self.rootsView = [self.view viewWithTag:_num+100];
        if (_num != 0) {
            CGPoint point = CGPointMake(0, 395*_num);
            [self.superRootView setContentOffset:point animated:YES];
        }else{
            CGPoint point = CGPointMake(0, 0);
            [self.superRootView setContentOffset:point animated:YES];
        }
        //临时存放数据
        //存放的还是一个个的model数据
        self.tempArray = [[DetailDB sharedInstance]fetchBySession:self.yearString bod:self.currentStr];
        
        //其他的波段不能操作
        self.lastScrollView.userInteractionEnabled = NO;
        self.lastScrollView = [self.view viewWithTag:200+_num];
        self.lastScrollView.userInteractionEnabled = YES;
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先保存已编辑波段!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(clickTmier:) userInfo:alert repeats:NO];
    }
}
-(void)clickTmier:(NSTimer *)timer{
    UIAlertController *alert = timer.userInfo;
    [alert dismissViewControllerAnimated:YES completion:nil];
    [timer invalidate];
}
-(void)createMenuData{
    NSString *type = [NSString stringWithFormat:@"%@type",self.yearString];
    NSArray *typeArr = [_userDeft objectForKey:type];
    self.typeDataArr = [NSMutableArray arrayWithArray:typeArr];
}
-(void)createTableMenuView{
    self.goBackView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-200, 0, 200, 69)];
    _goBackView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    _goBackView.hidden = YES;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(10, 30, 50, 30);
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor colorWithRed:253.0/255 green:137.0/255 blue:24.0/255 alpha:1.0] forState:UIControlStateNormal];
    [back.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [back addTarget:self action:@selector(gogo) forControlEvents:UIControlEventTouchUpInside];
    [_goBackView addSubview:back];
    [self.view addSubview:_goBackView];
    
    self.viewFrame = CGRectMake(kWidth-200, 69, 200, kHeight);
    self.typeMenuView = [[UITableView alloc]initWithFrame:_viewFrame style:UITableViewStylePlain];
    _typeMenuView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    _typeMenuView.hidden = YES;
    _typeMenuView.delegate = self;
    _typeMenuView.dataSource = self;
    _typeMenuView.separatorColor = [UIColor lightGrayColor];
    //尾视图
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    _typeMenuView.tableFooterView = footView;
    [self.view addSubview:_typeMenuView];
}
-(void)gogo{
    self.goBackView.hidden = YES;
    self.typeMenuView.hidden = YES;
}
-(void)addTitleViews{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 69)];
    titleView.backgroundColor = [UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1.0];
    titleView.userInteractionEnabled = YES;
    [self.view addSubview:titleView];
    //标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kWidth-200)/2.0, 30, 200, 30)];
    label.text = @"编辑KT板";
    label.font = [UIFont systemFontOfSize:25];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:label];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(10, 30, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return01"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(ktBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backBtn];
    
    //保存按钮
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.frame = CGRectMake(55, 30, 25, 25);
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"storage01"] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(ktDoneClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:doneBtn];
    
    //删除按钮
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteBtn.frame = CGRectMake(100, 30, 25, 25);
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(ktDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_deleteBtn];
    
    //菜单
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    menuBtn.frame = CGRectMake(kWidth-45, 30, 25, 25);
    menuBtn.tintColor = [UIColor clearColor];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"classification"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(ktMenuClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:menuBtn];
    
}
//返回
//判断是不是第一次保存
-(void)ktBackClick:(UIButton *)button{
    if (self.rootsView.subviews.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //如果已经操作了，而且没有保存的话，就提示用户退出的时候是否保存,
    //如果保存过了，删除tempArray，就直接退出
    //如果不保存的话，就删除detailDB的session+bod数据，将tempArray还原
    //
    if (self.haveDelorMove == YES) {
        PopContentController *contentController = [[PopContentController alloc]init];
        __weak typeof(self)weakself = self;
        [contentController setDidSelectHandler:^(NSString *string) {
            NSString *backStrs = string;
            if ([backStrs isEqualToString:@"保存"]) {//保存
                [self ktDoneClick];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{//不保存
                [[DetailDB sharedInstance]deleteBySession:weakself.yearString andBond:weakself.currentStr];
                for (int i = 0; i < weakself.tempArray.count; i ++) {
                    [[DetailDB sharedInstance]addDetailModel:weakself.tempArray[i]];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        contentController.modalPresentationStyle = UIModalPresentationPopover;
        contentController.preferredContentSize = CGSizeMake(100, 100);
        UIPopoverPresentationController *popController = contentController.popoverPresentationController;
        popController.sourceView = button;
        popController.sourceRect = button.bounds;
        popController.delegate = self;
        popController.permittedArrowDirections = UIPopoverArrowDirectionDown;
        [self presentViewController:contentController animated:NO completion:nil];
    }else{
        //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
//保存
-(void)ktDoneClick{
    self.changeView.layer.borderWidth = 0;
    if (self.rootsView.subviews.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你还没有挑选衣服" message:@"快去添加吧" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        //保存的话就删除原先的tempArray,将tempArray跟新为最新的detail,用于用户可以保存后不退出的情况下再次编辑
        //
        //
        //判断对应的波段是否有数据
        //如果有数据就更新
        //没有就添加
        self.tempArray = nil;
        if ([[KTDBManager sharedInstance]fetchBySession:_yearString bod:_currentStr].count == 0) {
            [[KTDBManager sharedInstance]addKTModel:[self currentKTModel]];
        }else{
            [[KTDBManager sharedInstance]update:[self currentKTModel]];
        }
        self.tempArray = [[DetailDB sharedInstance]fetchBySession:_yearString bod:_currentStr];
        self.haveDelorMove = NO;
        self.turnBod = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已保存！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:alert repeats:NO];
    }
}
-(void)timer:(NSTimer *)timer{
    UIAlertController *alert = timer.userInfo;
    [alert dismissViewControllerAnimated:YES completion:nil];
    [timer invalidate];
}
-(KTModel *)currentKTModel{
    self.rootsView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*8, 400);
    UIGraphicsBeginImageContext(self.rootsView.bounds.size);
    [_rootsView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewBeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    KTModel *ktModel = [[KTModel alloc]init];
    ktModel.ktDetail = [NSString stringWithFormat:@"%@%@",_yearString,self.currentStr];
    ktModel.ktImage = viewBeImage;
    ktModel.ktYear = _yearString;
    ktModel.ktBod = self.currentStr;
    return ktModel;
}
//删除
-(void)ktDeleteClick{
    NSString *detailTag = [NSString stringWithFormat:@"%ld",(long)self.changeView.tag];
    [[DetailDB sharedInstance]deleteByDetailTag:detailTag];
    [self.changeView removeFromSuperview];
    [[KTDBManager sharedInstance]update:[self currentKTModel]];
    //
    self.haveDelorMove = YES;
}
//菜单
-(void)ktMenuClick:(UIButton *)button{
    self.typeMenuView.hidden = NO;
    self.goBackView.hidden = NO;
}
#pragma mark - tableview dele
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.typeDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.typeDataArr[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 25, 25);
    //这里换一下图片
    [button setBackgroundImage:[UIImage imageNamed:@"jt"] forState:UIControlStateNormal];
    cell.accessoryView = button;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到详情
    self.didSelectType = self.typeDataArr[indexPath.row];
//    self.typeMenuView.hidden = YES;
//    self.goBackView.hidden = YES;
    [self createDetailData];
    [self createDetailView];
}
-(void)createDetailData{
    NSString *yearString = [_userDeft objectForKey:@"selectSTR"];
    self.detailDataArr = [[DataBase shareInstance]fetchBySession:yearString andType:_didSelectType];
}
-(void)createDetailView{
    self.detailHeadView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-200, 0, 200, 69)];
    _detailHeadView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(10, 35, 25, 25);
    [back setBackgroundImage:[UIImage imageNamed:@"return01"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(tgo) forControlEvents:UIControlEventTouchUpInside];
    [_detailHeadView addSubview:back];
    self.detailMidLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 100, 40)];
    _detailMidLable.text = self.didSelectType;
    _detailMidLable.textColor = [UIColor whiteColor];
    _detailMidLable.textAlignment = NSTextAlignmentCenter;
    _detailMidLable.font = [UIFont systemFontOfSize:25];
    [_detailHeadView addSubview:_detailMidLable];
    [self.view addSubview:_detailHeadView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(180, 180);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.detailMenuView = [[UICollectionView alloc]initWithFrame:CGRectMake(kWidth-200, 69, 200, kHeight-75) collectionViewLayout:layout];
    _detailMenuView.delegate = self;
    _detailMenuView.dataSource = self;
    _detailMenuView.showsVerticalScrollIndicator = NO;
    _detailMenuView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    //注册cell
    [_detailMenuView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_detailMenuView];
}
-(void)tgo{
    self.detailHeadView.hidden = YES;
    self.detailMenuView.hidden = YES;
}
#pragma mark - collectionview data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.detailDataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
    ClothPhoto *cloth = self.detailDataArr[indexPath.row];
    UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    photoView.backgroundColor = [UIColor whiteColor];
    photoView.image = cloth.image;
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundView = photoView;
    return cell;
}
//点击一件衣服
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     ClothPhoto *cloth = self.detailDataArr[indexPath.row];
    UIScrollView *currentScroll = [self.view viewWithTag:self.num+200];
    //点击一件衣服，就新建一个uiimageview
    NSInteger number = arc4random() % 6;
    UIImageView *currentView = [[UIImageView alloc]initWithFrame:CGRectMake(currentScroll.contentOffset.x+50+number*10, 50+number*10, 200, 240)];
    currentView.contentMode = UIViewContentModeScaleAspectFit;
    currentView.userInteractionEnabled = YES;
    currentView.image = cloth.image;
    //tag值唯一标识一个view，用于修改，删除
    currentView.tag = [[self currentTimer] longLongValue];
    NSLog(@"当前的tag值%ld",(long)currentView.tag);
    [self.rootsView addSubview:currentView];
   
    [self addGesture:currentView];
    //
    self.haveDelorMove = YES;
    //保存每件衣服的frame
    //记录下每个cell，用于点击详情的时候取出来可以再编辑
    //先记录下添加的cell，点击保存了才保存，不保存的话就删除记录
    //记录当前正在改变的视图
    self.changeView = currentView;
    [[DetailDB sharedInstance]addDetailModel:[self currentDetail]];
    NSLog(@"已经添加了数据数%lu",(unsigned long)[[DetailDB sharedInstance]fetchBySession:_yearString bod:_currentStr].count);
}
//给当前操作的视图添加手势
-(void)addGesture:(UIImageView *)imageView{
    //拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [imageView addGestureRecognizer:pan];
    //捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    [imageView addGestureRecognizer:pinch];
    //长按手势
 //   UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
    //[imageView addGestureRecognizer:longTap];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
}
//当前的时间戳
-(NSString *)currentTimer{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@",date);
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
    NSLog(@"当前时间%@",timeLocal);
    return timeLocal;
}
-(DetailModel *)currentDetail{
    DetailModel *detailModel = [[DetailModel alloc]init];
    //跟新当前操作视图的frame
    detailModel.orignX = self.changeView.frame.origin.x;
    detailModel.orignY = self.changeView.frame.origin.y;
    detailModel.frameWidth = self.changeView.frame.size.width;
    detailModel.frameHeight = self.changeView.frame.size.height;
    detailModel.image = self.changeView.image;
    detailModel.detailTag = [NSString stringWithFormat:@"%ld",self.changeView.tag];
    detailModel.detailYear = _yearString;
    detailModel.detailBod = _currentStr;
    return detailModel;
}
//如果移动的时候只是记录下他的frame，放在一个数组里面去。点击保存的时候才会更新数据库
//这样就不会出现移动就改改变KT板的布局了
//pan移动。。
-(void)pan:(UIPanGestureRecognizer *)pan{
    UIImageView *currentView = (UIImageView *)pan.view;
    CGPoint point = [pan translationInView:self.rootsView];
    CGPoint center = currentView.center;
    center.x += point.x;
    center.y += point.y;
    currentView.center = center;
    // 不让它累加
    [pan setTranslation:CGPointZero inView:self.rootsView];
    self.changeView = currentView;
    //haveDelorMove属性用来判断是不是修改过
    self.haveDelorMove = YES;
    //移动修改数据库
   //
    if (pan.state == UIGestureRecognizerStateEnded) {
        [[DetailDB sharedInstance]update:[self currentDetail]];
        NSLog(@"%f",self.changeView.frame.origin.x);
    }
}
//pinch收缩。。
-(void)pinch:(UIPinchGestureRecognizer *)pinch{
    UIImageView *currentView = (UIImageView *)pinch.view;
    currentView.transform = CGAffineTransformScale(currentView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0;

    self.changeView = currentView;
    //
    self.haveDelorMove = YES;
    //收缩修改数据库
    //
    if (pinch.state == UIGestureRecognizerStateEnded) {
        NSLog(@"缩放结束");
        [[DetailDB sharedInstance]update:[self currentDetail]];
    }
}
//长安删除
-(void)longTap:(UILongPressGestureRecognizer *)longTap{
    UIImageView *currentView = (UIImageView *)longTap.view;
    self.changeView = currentView;
    currentView.layer.borderWidth = 2.0;
    currentView.layer.borderColor = kBordColor;
    UIView *rootView = [self.view viewWithTag:self.num+100];
    [rootView bringSubviewToFront:currentView];
}
-(void)tap:(UITapGestureRecognizer *)tap{
    UIImageView *currentView = (UIImageView *)tap.view;
    self.changeView = currentView;
    currentView.layer.borderWidth = 2.0;
    currentView.layer.borderColor = kBordColor;
    UIView *rootView = [self.view viewWithTag:self.num+100];
    [rootView bringSubviewToFront:currentView];
}
#pragma mark - gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.changeView.layer.borderWidth = 0;
}
-(void)ktClicks{
    self.detailMenuView.hidden = YES;
    self.typeMenuView.hidden = NO;
}
@end
