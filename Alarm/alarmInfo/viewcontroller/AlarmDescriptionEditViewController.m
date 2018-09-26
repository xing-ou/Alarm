//
//  AlarmDescriptionEditViewController.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmDescriptionEditViewController.h"
#import "ColorManager.h"
#import <Masonry/Masonry.h>
@interface AlarmDescriptionEditViewController ()

@property(nonatomic,strong)UITextField *textField;

@end

@implementation AlarmDescriptionEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
-(void)textFieldValueChanged:(UITextField *)sender {
    if(_delegate != nil){
        [_delegate alarmDescriptionDidChange:sender.text];
    }
}


#pragma mark - 初始化view

-(void)setupView {
    self.navigationItem.title = @"标签";
    self.view.backgroundColor = [ColorManager mainBackgroundColor];
    _textField = [[UITextField alloc] init];
    _textField.text = self.currentDesc;
    _textField.textColor = [ColorManager mainTextColor];
    _textField.backgroundColor = [UIColor colorWithRed:0x11/255.0 green:0x11/255.0 blue:0x11/255.0 alpha:1.0];
    [_textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _textField.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(0);
        make.trailing.mas_equalTo(self.view).offset(0);
        make.centerY.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    [_textField becomeFirstResponder];
    
    UIView *divBefor = [[UIView alloc] init];
    divBefor.backgroundColor = [ColorManager divColor];
    [self.view addSubview:divBefor];
    [divBefor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.textField.mas_top);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *divAfter = [[UIView alloc] init];
    divAfter.backgroundColor = [ColorManager divColor];
    [self.view addSubview:divAfter];
    [divAfter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.textField.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
}


@end
