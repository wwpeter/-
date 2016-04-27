//
//  SettingsController.m
//  好品
//
//  Created by 朱明科 on 15/12/9.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "SettingsController.h"

#import "SessionsController.h"
#import "BodsController.h"
#import "TypeController.h"
#import "SuggestController.h"
#import "AboutViewController.h"
#import "PwdController.h"
#import "DesignController.h"
#import "ChooseSessionController.h"
#import "ActivationController.h"

#define kRect CGRectMake(300, 0, self.view.frame.size.width+300, self.view.frame.size.height)

@interface SettingsController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *setsTableview;
@property(nonatomic)NSArray *dataArray;
@property(nonatomic)NSArray *optionArray;
@property(nonatomic)UIViewController *currentController;
@property(nonatomic)NSArray *imgArr;
@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255  green:242.0/255  blue:242.0/255  alpha:1.0];
    
    [self createData];
    [self createUI];
    [self addChildControllers];//添加子控制器
}
-(void)createData{
    self.dataArray = @[@[@"添加年份季节",@"选择年份季节",@"上货周期",@"品类控制",@"添加设计师"],@[@"授权日期",@"手势锁"],@[@"意见反馈",@"关于"]];
    self.imgArr = @[@[@"year",@"time",@"band",@"category",@"icon_sjs"],@[@"suo01",@"gesture"],@[@"feedback",@"about"]];
}
//添加子控制器
-(void)addChildControllers{
    //年份季节----0
    SessionsController *sessionsController = [[SessionsController alloc]init];
    sessionsController.view.frame = kRect;
    [self addChildViewController:sessionsController];
    [self.view addSubview:sessionsController.view];
    self.currentController = sessionsController;
    
    //选择年份------1
    ChooseSessionController *chooseSessionController = [[ChooseSessionController alloc]init];
    chooseSessionController.view.frame = kRect;
    [self addChildViewController:chooseSessionController];
    
    //波段控制----2
    BodsController *bodController = [[BodsController alloc]init];
    bodController.view.frame = kRect;
    [self addChildViewController:bodController];
    
    //品类控制----3
    TypeController *typeController = [[TypeController alloc]init];
    typeController.view.frame = kRect;
    [self addChildViewController:typeController];
    
    //意见-----4
    SuggestController *suggestController = [[SuggestController alloc]init];
    suggestController.view.frame = kRect;
    [self addChildViewController:suggestController];
    
    //关于-----5
    AboutViewController *aboutController = [[AboutViewController alloc]init];
    aboutController.view.frame = kRect;
    [self addChildViewController:aboutController];
    
    //密码----6
    PwdController *pwdController = [[PwdController alloc]init];
    pwdController.view.frame = kRect;
    [self addChildViewController:pwdController];
    
    //设计师----7张三
    DesignController *designController = [[DesignController alloc]init];
    designController.view.frame = kRect;
    [self addChildViewController:designController];
    
    //授权日期
    ActivationController *acController = [[ActivationController alloc] init];
    acController.view.frame = CGRectMake(300, 0, self.view.frame.size.width+300, self.view.frame.size.height+64);
    [self addChildViewController:acController];
}
-(void)createUI{
    self.setsTableview.delegate = self;
    self.setsTableview.dataSource = self;
    self.setsTableview.separatorInset = UIEdgeInsetsZero;
    self.setsTableview.separatorColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    self.setsTableview.scrollEnabled = NO;
    
    UIView *views = [[UIView alloc]init];
    views.backgroundColor = [UIColor clearColor];
    self.setsTableview.tableFooterView = views;
}
#pragma mark - <uitableviewdelegate>
-(void)viewDidLayoutSubviews {
    if ([self.setsTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.setsTableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.setsTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.setsTableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        NSString *date = [user objectForKey:@"jihuoriqi"];
//        cell.detailTextLabel.text = date;
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
//        cell.detailTextLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgArr[indexPath.section][indexPath.row]]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    UIView *selectView = [[UIView alloc]init];
    selectView.frame = cell.frame;
    selectView.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    cell.selectedBackgroundView = selectView;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//点击cell，响应相应事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0://年份季节
            {
                [self showChildViewControllerWithIndex:0];
            }
                break;
            case 1://选择季节
            {
                [self showChildViewControllerWithIndex:1];
                
            }
                break;
            case 2://波段控制
            {
                [self showChildViewControllerWithIndex:2];
            }
                break;
            case 3://品类控制
            {
                [self showChildViewControllerWithIndex:3];
            }
                break;
            case 4://设计师
            {
                [self showChildViewControllerWithIndex:7];
            }
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){//锁
        switch (indexPath.row) {
            case 0: {
                [self showChildViewControllerWithIndex:8];
            }
                break;
            case 1:
            {
                [self showChildViewControllerWithIndex:6];
            }
                break;
            default:
                break;
        }
    }else{//第三section
        switch (indexPath.row) {
            case 0://意见反馈
            {
                [self showChildViewControllerWithIndex:4];
            }
                break;
            case 1://关于
            {
                [self showChildViewControllerWithIndex:5];
            }
                break;
            default:
                break;
        }
    }
}
//显示哪一个子控制器
-(void)showChildViewControllerWithIndex:(NSInteger)index{
    NSAssert(self.childViewControllers.count > index, @"断言失败：传的索引值不合理");
    UIViewController *targetController = self.childViewControllers[index];
    if (self.currentController == targetController) {
        return;
    }
    [self transitionFromViewController:_currentController toViewController:targetController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
    } completion:^(BOOL finished) {
        self.currentController = targetController;
    }];
}
//默认cell选中第一行
-(void)viewDidAppear:(BOOL)animated
{
//    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.setsTableview selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    [super viewDidAppear:animated];
//    [self showChildViewControllerWithIndex:0];
}
@end
