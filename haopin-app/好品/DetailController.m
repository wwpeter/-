//
//  DetailController.m
//  好品
//
//  Created by 朱明科 on 15/12/22.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "DetailController.h"
#import "RemarkController.h"
#import "ChangeColorController.h"
#import "ColerDB.h"
#import "KuoXingController.h"
#import "MenuPopController.h"
#import "ColorModel.h"

#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kColor  [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0]
@interface DetailController ()<UIScrollViewDelegate,UIPopoverPresentationControllerDelegate>
@property(nonatomic)UIScrollView *scrollView;
@property(nonatomic)RemarkController *remarkController;
@property (nonatomic) UIPageControl *pageControl;
@property(nonatomic)UIImageView *backImageView;
@property(nonatomic)UILabel *priceLable1;//价格
@property(nonatomic)UILabel *pingLable1;//评款
@property(nonatomic)UILabel *yangLable1;//样品
@property(nonatomic)UILabel *typeLable1;//品类
@property(nonatomic)NSInteger number;
@property(nonatomic)NSMutableArray *colorArr;
@end

@implementation DetailController
-(RemarkController *)remarkController{
    if (_remarkController == nil) {
        _remarkController = [[RemarkController alloc]init];
        _remarkController.view.frame = CGRectMake(300, 100, self.view.frame.size.width-600, 540);
        _remarkController.tmpCloth = self.cloth;
        __weak typeof(self)weakSelf = self;
        [_remarkController setDetailHandler:^{
            weakSelf.remarkController.tmpCloth = [[DataBase shareInstance]fetchByInd:weakSelf.cloth.ind];
            [weakSelf initMenuData];
        }];
    }
    return _remarkController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createData];
    [self createUI];
    [self addMenu];
    [self initMenuData];
    [self addScroll];
}
-(void)createData{
    self.colorArr = nil;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:_cloth.image,_cloth.backImage, nil];
    self.number = array.count;
    self.photoModelArray = array;
    NSMutableArray *mutColorArray = [[ColerDB sharedInstance]fetchByTag:_cloth.ind andDetail:@"加色"];
    self.colorArr = mutColorArray;
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSInteger i = 0; i < mutColorArray.count; i ++) {
        ColorModel *model = mutColorArray[i];
        [tmpArray addObject:model.colorImage];
    }
    [self.photoModelArray addObjectsFromArray:tmpArray];
}
-(void)createUI{
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    editButton.frame = CGRectMake(0, 0, 49, 49);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:kColor forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [editButton addTarget:self action:@selector(deleClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteBtn.frame = CGRectMake(0, 0, 49, 49);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:kColor forState:UIControlStateNormal];
    [deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [deleteBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItems = @[rightItem2,rightItem1];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 49, 49);
    [backBtn setTitleColor:kColor forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}
//删除
-(void)edit{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该货品将被删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[DataBase shareInstance]deleteClothByInd:self.cloth.ind];
        [[ColerDB sharedInstance]deleteByTag:self.cloth.ind];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.refreshHandler) {
            self.refreshHandler();
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
//备注按钮
-(void)deleClick{
    if (self.childViewControllers.count == 0) {
        [self addChildViewController:self.remarkController];
        [self.view addSubview:_remarkController.view];
    }
}
-(void)backView{
    if (self.refreshHandler) {
        self.refreshHandler();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addMenu{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-320, 0, 1, kHeight)];
    lineView.backgroundColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:0.3];
    [self.view addSubview:lineView];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(kWidth-280, 38, 70, 1)];
    line2.backgroundColor = kColor;
    [self.view addSubview:line2];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(kWidth-110, 38, 70, 1)];
    line3.backgroundColor = kColor;
    [self.view addSubview:line3];
    UILabel *mess = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-210, 30, 100, 20)];
    mess.text = @"产品信息";
    mess.textColor = kColor;
    mess.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:mess];
    
    UILabel *priceLable = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-280, 70, 50, 20)];
    priceLable.text = @"价格：";
    priceLable.textColor = kColor;
    priceLable.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:priceLable];
    self.priceLable1 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-240, 70, 100, 20)];
//    if (self.cloth.price) {
//        _priceLable1.text = [NSString stringWithFormat:@"￥%@",self.cloth.price];
//    }
    _priceLable1.textColor = kColor;
    _priceLable1.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_priceLable1];
    //
    UILabel *pingLable = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-280, 110, 50, 20)];
    pingLable.text = @"评款：";
    pingLable.textColor = kColor;
    pingLable.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:pingLable];
    self.pingLable1 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-240, 110, 100, 20)];
//    _pingLable1.text = self.cloth.pinkuan;
    _pingLable1.textColor = kColor;
    _pingLable1.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_pingLable1];
    //
    UILabel *yangLable = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-280, 150, 50, 20)];
    yangLable.text = @"样品：";
    yangLable.textColor = kColor;
    yangLable.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:yangLable];
    self.yangLable1 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-240, 150, 100, 20)];
//    _yangLable1.text = self.cloth.color;
    _yangLable1.textColor = kColor;
    _yangLable1.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_yangLable1];
    //
    UILabel *typeLable = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-280, 190, 50, 20)];
    typeLable.text = @"品类：";
    typeLable.textColor = kColor;
    typeLable.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:typeLable];
    self.typeLable1 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-240, 190, 100, 20)];
//    _typeLable1.text = self.cloth.type;
    _typeLable1.textColor = kColor;
    _typeLable1.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_typeLable1];
    //
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(kWidth-280, 250, 70, 1)];
    line4.backgroundColor = kColor;
    [self.view addSubview:line4];
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(kWidth-110, 250, 70, 1)];
    line5.backgroundColor = kColor;
    [self.view addSubview:line5];
    UILabel *design = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-210, 240, 100, 20)];
    design.text = @"产品设计";
    design.textColor = kColor;
    design.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:design];
    //加色
    UIButton *jsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    jsButton.frame = CGRectMake(kWidth-240, 280, 160, 40);
    [jsButton setTitle:@"加色" forState:UIControlStateNormal];
    [jsButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    [jsButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    jsButton.backgroundColor = [UIColor colorWithRed:244.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    [jsButton addTarget:self action:@selector(jsAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jsButton];
    //廓形
    UIButton *kxButton = [UIButton buttonWithType:UIButtonTypeSystem];
    kxButton.frame = CGRectMake(kWidth-240, 330, 160, 40);
    [kxButton setTitle:@"廓形" forState:UIControlStateNormal];
    [kxButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    [kxButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    kxButton.backgroundColor = [UIColor colorWithRed:244.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    [kxButton addTarget:self action:@selector(kxAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:kxButton];
    
}
-(void)initMenuData{
    self.cloth = [[DataBase shareInstance]fetchByInd:self.cloth.ind];
    if (self.cloth.price) {
        _priceLable1.text = [NSString stringWithFormat:@"￥%@",self.cloth.price];
    }
    _pingLable1.text = self.cloth.pinkuan;
    _yangLable1.text = self.cloth.color;
    _typeLable1.text = self.cloth.type;
}
-(void)addScroll{
    //
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(200, 100, 400, kHeight-270)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    for (NSInteger i = 0; i < self.photoModelArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        if (i >= _number) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            [imageView addGestureRecognizer:longPress];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = self.photoModelArray[i];
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*self.photoModelArray.count, 0);
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(400, CGRectGetMaxY(_scrollView.frame)+10, _scrollView.frame.size.width-380, 30)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.numberOfPages = self.photoModelArray.count;
    [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
}
#pragma mark - 加色
-(void)jsAction{
    ChangeColorController *changeColorController = [[ChangeColorController alloc]init];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.cloth.image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    changeColorController.ysImage = self.cloth.image;
    changeColorController.kImageView = imageView;
    changeColorController.isAddColor = YES;
    __weak typeof(self)weakSelf = self;
    [changeColorController setDoneHandler:^(UIImageView *imageView) {
        weakSelf.backImageView = imageView;
        weakSelf.backImageView.UUTag = weakSelf.cloth.ind ;
        [[ColerDB sharedInstance]addDetailModel:[self currentBackView]];
        [weakSelf.scrollView removeFromSuperview];
        [weakSelf.pageControl removeFromSuperview];
        weakSelf.photoModelArray = nil;
        [self createData];
        [self addScroll];
    }];
    [self.navigationController pushViewController:changeColorController animated:YES];
}
-(ColorModel *)currentBackView{
    ColorModel *model = [[ColorModel alloc]init];
    model.colorImage = self.backImageView.image;
    model.tag = self.cloth.ind;
    model.detail = @"加色";
    model.colorID = [self currentTimer];
    return model;
}
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
#pragma mark - 廓形
-(void)kxAction{
    KuoXingController *kxController = [[KuoXingController alloc]init];
    CIContext *context = [CIContext contextWithOptions:nil];
    UIImage *image = self.cloth.image;
    NSData *data = UIImagePNGRepresentation(image);
    CIImage *ciImage = [CIImage imageWithData:data];
    CIFilter *ldFliter = [CIFilter filterWithName:@"CIExposureAdjust"];
    [ldFliter setValue:ciImage forKey:kCIInputImageKey];
    [ldFliter setValue:[NSNumber numberWithFloat:10] forKey:@"inputEV"];
    CIImage *outputImage = [ldFliter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    kxController.backImage = newImg;
    [self.navigationController pushViewController:kxController animated:YES];
}
#pragma mark - pageControl 的代理

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 减速结束
    // 在这个代理方法中检测scrollView偏移量，从而计算出当前滚动到第几页了，设置页码指示器，让它指定到相应的页
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPage = page;
}
- (void)pageControlClick:(UIPageControl *)pageControl {
    NSInteger currentPage = pageControl.currentPage;
    // 根据页码设置scrollView的滚动的偏移量
    [_scrollView setContentOffset:CGPointMake(currentPage*_scrollView.frame.size.width, 0) animated:YES];
}
-(void)longPress:(UILongPressGestureRecognizer *)longPress{
    NSInteger currentPage = _pageControl.currentPage;
    //弹出POP
    MenuPopController *menuPOPController = [[MenuPopController alloc]init];
    menuPOPController.dataArray = [NSArray arrayWithObjects:@"删除", nil];
    [menuPOPController setSelectHandler:^(NSString *string) {
        if (currentPage >= _number) {
            NSInteger color = currentPage - _number;
            ColorModel *model = self.colorArr[color];
            [[ColerDB sharedInstance]deleteByTag:self.cloth.ind andId:model.colorID];
            [self.scrollView removeFromSuperview];
            [self.pageControl removeFromSuperview];
            self.photoModelArray = nil;
            [self createData];
            [self addScroll];
        }
    }];
    menuPOPController.modalPresentationStyle = UIModalPresentationPopover;
    menuPOPController.preferredContentSize = CGSizeMake(60, 40);
    UIPopoverPresentationController *popController = menuPOPController.popoverPresentationController;
    popController.sourceView = longPress.view;
    popController.sourceRect = longPress.view.bounds;
    popController.delegate = self;
    popController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    [self presentViewController:menuPOPController animated:YES completion:nil];
}
@end
