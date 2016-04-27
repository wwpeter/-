//
//  NewKTController.m
//  haopin
//
//  Created by 朱明科 on 16/3/10.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "NewKTController.h"
#import "NewKTDB.h"
#import "NewKTDetail.h"
#import "ZhuTiDB.h"
#import "NewAddKTViewController.h"
#import "KuZiDB.h"
#import "NewKTDB.h"
#import "ZhuTiController.h"
#import "ScrollDB.h"

@interface NewKTController ()

@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic,copy)NSString *currentYear;
@property(nonatomic)NSMutableArray *dateArr;
@property(nonatomic)NSMutableArray *haveDate;
@property (nonatomic) UIScrollView *xiaZhuangScroll;
@property (nonatomic) UIScrollView *shangYiScroll;
@end

@implementation NewKTController
-(NSMutableArray *)dateArr{
    if (_dateArr == nil) {
        _dateArr = [[NSMutableArray alloc]init];
    }
    return _dateArr;
}
-(NSMutableArray *)haveDate{
    if (_haveDate == nil) {
        _haveDate = [[NSMutableArray alloc]init];
    }
    return _haveDate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self creatData];
    [self addButton];
   
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self createUI];
}
-(void)creatData{
    self.dateArr = nil;
    self.currentYear = [_userDeft objectForKey:@"selectSTR"];
    if (self.currentYear == nil) {
        self.dateArr = nil;
    } else {
        self.dateArr = [_userDeft objectForKey:self.currentYear];//上货周期
    }
    
    NSString *str = [NSString stringWithFormat:@"%@panduan",self.currentYear];
    self.haveDate = [_userDeft objectForKey:str];
}
-(void)addButton{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(0, 0, 45, 44);
    [addButton setImage:[[UIImage imageNamed:@"add-to"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addKT:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    
    UIButton *deleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleButton.frame = CGRectMake(0, 0, 45, 44);
    [deleButton setImage:[[UIImage imageNamed:@"delete01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [deleButton addTarget:self action:@selector(deleKT:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[item1];
}
-(void)addKT:(UIButton *)button{
     NSString *str = [NSString stringWithFormat:@"%@panduan",self.currentYear];
    NSArray *arr = [_userDeft objectForKey:str];
    if (arr.count == self.dateArr.count) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"上货周期已经增添完毕，请点击下面进行编辑" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }]];
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        NewAddKTViewController *newAddKTController = [[NewAddKTViewController alloc]init];
        [newAddKTController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newAddKTController animated:YES];
    }
    
}
-(void)deleKT:(UIButton *)button{

}
-(void)createUI{
  
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   // NSInteger num = self.dateArr.count;
    NSInteger num = self.haveDate.count;
    CGFloat width = (self.view.frame.size.width-(num+1)*20)/num;
    for (NSInteger i = 0; i < num; i ++) {
        UIView *views = [[UIView alloc]initWithFrame:CGRectMake(20+(i*(width+20)), 20, width, self.view.frame.size.height)];
        views.userInteractionEnabled = YES;
        views.backgroundColor = [UIColor whiteColor];
        views.layer.borderWidth = 1;
        views.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
        views.tag = 100+i;
       // views.backgroundColor = [UIColor whiteColor];
       
        [self addDetail:views];
        [self addGesture:views];
        [self.view addSubview:views];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
    [self.view addSubview:lineView];
    
}
-(void)addDetail:(UIView *)view{
    //NSInteger num = self.dateArr.count;
    NSInteger num = self.haveDate.count;
    CGFloat width = (self.view.frame.size.width-(num+1)*20)/num;
    //标题
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width-40, 50)];
    lable.textAlignment = NSTextAlignmentCenter;
//    lable.backgroundColor = [UIColor colorWithRed:56.0/256 green:165.0/256 blue:254.0/256 alpha:1.0];
    lable.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    //lable.text = titleStr;
    lable.font = [UIFont systemFontOfSize:17];
    lable.textColor = [UIColor lightGrayColor];
    lable.text = self.haveDate[view.tag-100];
    [view addSubview:lable];
    
    UIButton *zhutiBut = [UIButton buttonWithType:UIButtonTypeCustom];
    zhutiBut.frame = CGRectMake(width- 43, 5, 40, 40);
    [zhutiBut setTitle:@"主题" forState:UIControlStateNormal];
    zhutiBut.layer.cornerRadius = 20;
    zhutiBut.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [zhutiBut addTarget:self action:@selector(toZhuTiController:) forControlEvents:UIControlEventTouchUpInside];
    zhutiBut.tag = view.tag;
    [view addSubview:zhutiBut];
    //详情
    UIScrollView *detailScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, width, self.view.frame.size.height-49)];
    detailScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubViews:detailScrollView andViewTag:view.tag andWidth:width];
    detailScrollView.contentSize = CGSizeMake(width, 1050);
    [view addSubview:detailScrollView];
}

- (void)toZhuTiController:(UIButton *)button{
    
    NSString *string = self.haveDate[button.tag - 100];
    //year+date
   // NSString *yearAndDate = [NSString stringWithFormat:@"%@%@",self.currentYear,string];
    
    ZhuTiController *controller = [[ZhuTiController alloc] init];
    //制定返回按钮
    controller.currentData = string;
    controller.currentYear = self.currentYear;
    controller.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"主题";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
//每个详情视图上再加上货品，货杆
-(void)addSubViews:(UIScrollView *)scrollView andViewTag:(NSInteger)tag andWidth:(NSInteger)width{
    CGFloat contentHigh = 80;
    NSString *currentDateStr = self.haveDate[tag-100];
    //上衣的截图
    ScrollModel *model = [[ScrollDB sharedInstance] fetchByYear:self.currentYear andDate:currentDateStr andType:@"shangyi"];
    UIImage *image = model.image;
    CGFloat winthScroll = image.size.width/2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winthScroll, contentHigh)];
    imageView.image = image;
    _shangYiScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, contentHigh*2)];
    [_shangYiScroll addSubview:imageView];
    _shangYiScroll.showsHorizontalScrollIndicator = NO;
   
    //夏装的截图
    ScrollModel *model1 = [[ScrollDB sharedInstance] fetchByYear:self.currentYear andDate:currentDateStr andType:@"xiazhuang"];
    UIImage *image1 = model1.image;
    CGFloat winthScroll1 = image1.size.width/2;
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentHigh, winthScroll1, contentHigh)];
    imageView1.image = image1;
    if (image.size.width >= image1.size.width) {
        _shangYiScroll.contentSize = CGSizeMake(winthScroll, contentHigh);
    } else {
        _shangYiScroll.contentSize = CGSizeMake(winthScroll1, contentHigh);
    }
    [_shangYiScroll addSubview:imageView1];
    [scrollView addSubview:_shangYiScroll];
    //杆的frame  高400 屏幕=宽  contentsize width+800
    //杆数
    NSArray *arrOFGan = [NSArray arrayWithObjects:@"第一杆",@"第二杆",@"第三杆",@"第四杆",@"第五杆",@"第六杆", nil];;
    for (NSInteger i = 0; i < arrOFGan.count; i ++) {
        ZhuTiModel *model = [[ZhuTiDB sharedInstance]fetchKTByYear:self.currentYear andDate:currentDateStr andDetail:arrOFGan[i]];
        UIImageView *ganImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (170)+((150)*i),width, 150)];
        ganImageView.backgroundColor = [UIColor whiteColor];
        ganImageView.contentMode = UIViewContentModeScaleAspectFit;
        ganImageView.image = model.image;
        [scrollView addSubview:ganImageView];
        contentHigh += 200;
    }
    scrollView.contentSize = CGSizeMake(0, contentHigh);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
}
-(void)addGanSubViews:(UIImageView *)ganImageView num:(NSInteger)num currentGanArr:(NSArray *)currentGanArr currentDateStr:(NSString *)currentDateStr{
    UIImageView *detailView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width+800, 400)];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, self.view.frame.size.width-150, 355)];
    imageView1.image = [UIImage imageNamed:@"yifujia.png"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-130, 30, self.view.frame.size.width-150, 355)];
    imageView2.image = [UIImage imageNamed:@"yifujia.png"];
    [detailView addSubview:imageView1];
    [detailView addSubview:imageView2];
    NSMutableArray *ganViewsArr = [[NewKTDetail sharedInstance]fetchKTByYear:self.currentYear andDate:currentDateStr andGan:currentGanArr[num]];
    for (NSInteger i = 0; i < ganViewsArr.count; i ++) {
        NewKTDetailModel *model = ganViewsArr[i];
        UIImageView *views = [[UIImageView alloc]initWithFrame:CGRectMake(model.orignX, model.orignY, model.frameWidth, model.frameHeight)];
        views.image = model.image;
        [detailView addSubview:views];
    }
    
    UIGraphicsBeginImageContext(detailView.bounds.size);
    [detailView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewBeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //ganImageView.contentMode = UIViewContentModeScaleAspectFit;
    ganImageView.image = viewBeImage;
}
-(void)addGesture:(UIView *)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [view addGestureRecognizer:tap];
}
-(void)tap:(UITapGestureRecognizer *)tap{
    UIView *currentView = (UIView *)tap.view;
    NSInteger tags = currentView.tag-100;
    //NSArray *array = self.dateArr[tags];
    //当前上货周期
    //NSString *string = [NSString stringWithFormat:@"%@-%@%@",array[1],array[2],array[0]];
    NSString *string = self.haveDate[tags];
    //year+date
    NSString *yearAndDate = [NSString stringWithFormat:@"%@%@",self.currentYear,string];
    NewAddKTViewController *newDetailKTController = [[NewAddKTViewController alloc]init];
//    [newDetailKTController setHandler:^(NSString *refresh) {
//        if ([refresh isEqualToString:@"YES"]) {
//            [self creatData];
//            [self createUI];
//        }
//    }];
    newDetailKTController.currentData = string;
    newDetailKTController.currentYear = self.currentYear;
    newDetailKTController.yearAndDate = yearAndDate;
    newDetailKTController.isEdit = YES;
    newDetailKTController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newDetailKTController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    //获取通知中心单例对象
//    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
//    [center addObserver:self selector:@selector(notice:) name:@"refresh" object:nil];
    [self creatData];
    [self createUI];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
