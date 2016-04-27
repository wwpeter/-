//
//  CombinDetailController.m
//  好品
//
//  Created by 朱明科 on 15/12/25.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "CombinDetailController.h"
#import "AddCombinController.h"
#import "DBManager.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface CombinDetailController ()
@property(nonatomic)UIImageView *imageView;
@end

@implementation CombinDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70, kWidth, kHeight-70)];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_imageView addGestureRecognizer:tap];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    [_imageView addGestureRecognizer:pinch];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = _combin.combinImage;
    [self.view addSubview:_imageView];
    
    [self addTitleView];
}
-(void)tap:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)pinch:(UIPinchGestureRecognizer *)pinch{
    UIImageView *currentView = (UIImageView *)pinch.view;
    currentView.transform = CGAffineTransformScale(currentView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0;
}
-(void)pan:(UIPanGestureRecognizer *)pan{
    UIImageView *currentView = (UIImageView *)pan.view;
    CGPoint point = [pan translationInView:self.view];
    CGPoint center = currentView.center;
    center.x += point.x;
    center.y += point.y;
    currentView.center = center;
    [pan setTranslation:CGPointZero inView:self.view];
}
-(void)addTitleView{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kWidth, 49)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    //返回
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.frame = CGRectMake(10, 0, 49, 49);
    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [returnBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    [returnBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [returnBtn addTarget:self action:@selector(returnclick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:returnBtn];
    //标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kWidth-200)/2.0, 5, 200, 30)];
    label.text = self.combin.combinName;
    label.font = [UIFont systemFontOfSize:25];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:label];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    editButton.frame = CGRectMake(kWidth-60, 0, 49, 49);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [editButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:editButton];
    
    //删除
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.frame = CGRectMake(kWidth-120, 0, 49, 49);
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [deleteButton addTarget:self action:@selector(deletes:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:deleteButton];
}
-(void)edit:(UIButton *)button{
    AddCombinController *addCombinController = [[AddCombinController alloc]init];
    addCombinController.edit = YES;
    addCombinController.currentCombinDetail = self.combin.combinDetail;
    addCombinController.curentCombinName = self.combin.combinName;
    [addCombinController setEditCombinHandler:^{
        self.combin = [[DBManager sharedInstance]fetchByDetail:_combin.combinDetail];
         _imageView.image = _combin.combinImage;
    }];
    [self presentViewController:addCombinController animated:YES completion:nil];
}
-(void)deletes:(UIButton *)button{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您将要删除该组合" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[DBManager sharedInstance]deleteByDetailTimer:self.combin.combinDetail];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)returnclick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss:) name:@"backDismiss" object:nil];
//}
//-(void)dismiss:(NSNotification *)info{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}
@end
