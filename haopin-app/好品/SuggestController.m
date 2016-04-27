//
//  SuggestController.m
//  好品
//
//  Created by 朱明科 on 15/12/16.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "SuggestController.h"
#import <QuartzCore/QuartzCore.h>

@interface SuggestController ()<UITextViewDelegate>
@property(nonatomic)UITextView *suggestText;
@property(nonatomic)UITextField *addressText;
@property(nonatomic,copy)NSString *textString;
@end

@implementation SuggestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}
-(void)createUI{
    UIView *tmpView = [[UIView alloc]initWithFrame:CGRectMake(1, 0, 723, 768)];
    tmpView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tmpView];
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, 650, 44)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"意见反馈";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(1, 44, 723, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    [self.view addSubview:lineView];
    //提交
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(651, 0, 73, 44);
    doneButton.backgroundColor = [UIColor whiteColor];
    [doneButton.titleLabel setFont:titleLabel.font];
    [doneButton setTitle:@"提交" forState:UIControlStateNormal];
        UIColor *xxColor = [UIColor colorWithRed:72.0/255 green:200.0/255 blue:90.0/255 alpha:1.0];
    [doneButton setTintColor:xxColor];
    [doneButton addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    //意见
    self.suggestText = [[UITextView alloc]initWithFrame:CGRectMake(10, 50, 703, 150)];
    _suggestText.layer.borderWidth = 1.0;
    UIColor *color = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
    _suggestText.layer.borderColor = color.CGColor;
    _suggestText.textAlignment = NSTextAlignmentLeft;
    _suggestText.font = [UIFont systemFontOfSize:20];
    _suggestText.delegate = self;
   
    [self.view addSubview:_suggestText];
    //邮箱
    self.addressText = [[UITextField alloc]initWithFrame:CGRectMake(10, 210, 703, 50)];
    //_addressText.borderStyle = UITextBorderStyleLine;
    _addressText.layer.borderWidth = 1.0;
    _addressText.layer.borderColor = color.CGColor;
    _addressText.placeholder = @"输入您的邮箱(选填)";
    _addressText.backgroundColor = [UIColor whiteColor];
    UIView *placeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 45)];
    placeView.backgroundColor = [UIColor whiteColor];
    _addressText.leftView = placeView;
    _addressText.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_addressText];
    
        
}
-(void)doneBtnClick:(UIButton *)button{
    if (self.textString.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有输入任何内容！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"感谢您的反馈！" preferredStyle:UIAlertControllerStyleAlert];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:alertController repeats:NO];
        [self presentViewController:alertController animated:YES completion:nil];
        self.suggestText.text = nil;
        self.textString = nil;
    }

}
-(void)timer:(NSTimer *)timer{
    UIAlertController *alert = timer.userInfo;
    [self dismissViewControllerAnimated:alert completion:nil];
    [timer invalidate];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    self.textString = [NSString stringWithString:textView.text];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location > 240) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"字数超过240字！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }else{
        return YES;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.suggestText resignFirstResponder];
    [self.addressText resignFirstResponder];
}

@end
