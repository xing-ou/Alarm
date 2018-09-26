//
//  AlarmInfoTableViewController.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmInfoTableViewController.h"
#import "ColorManager.h"
#import "WeekDaySelectViewController.h"
#import "AlarmDescriptionEditViewController.h"
#import "AlarmNotifications.h"
#import "AlarmService.h"
#import "AlarmSoundSelectTableViewController.h"
#define RepeatCellIndex 0
#define AlarmDescriptionCellIndex 1
#define AlarmSoundCellIndex 2
#define AlarmRemindLaterCellIndex 3


@interface AlarmInfoTableViewController ()<WeekDaySelectViewControllerDelegate,AlarmDescriptionEditViewControllerDelegate,AlarmSoundSelectTableViewControllerDelegate>

@property(nonatomic,strong)UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UILabel *alarmRepeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmSoundLabel;
@property (weak, nonatomic) IBOutlet UISwitch *remindLaterSwitch;

@end

@implementation AlarmInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - delegate相关
-(void)weekDayDidSelect:(NSArray *)days {
    [_alarmDataSource setAlarmRepeatDays:days];
    _alarmRepeatLabel.text = [_alarmDataSource getAlarmRepeatInfo];
}

-(void)alarmDescriptionDidChange:(NSString *)desc {
    [_alarmDataSource setAlarmDescription:desc];
    _alarmDescriptionLabel.text = [_alarmDataSource getAlarmDescriptionInfo];
}

-(void)alarmSoundSelectDidSelectAtPath:(NSString *)path {
    _alarmDataSource.alarmModel.alarmSoundPath = path;
    _alarmSoundLabel.text = [path lastPathComponent];
}
#pragma mark - 界面事件
-(void)clickedCancelBtn:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickedSaveBtn:(UIBarButtonItem *)sender {
    [_alarmDataSource saveAlarm];
    [[NSNotificationCenter defaultCenter] postNotificationName:AlarmListShouldReloadNotification object:nil];
    [[AlarmService shareInstance] registAlarmWithModel:_alarmDataSource.alarmModel];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickedRemindLaterSwitch:(UISwitch *)sender {
    [_alarmDataSource setAlarmRemindLater:sender.on];
}


-(void)datePickerTimeChanged:(UIDatePicker *)picker {
    self.alarmDataSource.alarmModel.alarmTime = picker.date;
}

#pragma mark - Table相关

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_alarmDataSource sectionNum];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:return 4;
        case 1:return 1;
        default:return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(indexPath.row == RepeatCellIndex){
            WeekDaySelectViewController *vc = [[WeekDaySelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.delegate = self;
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == AlarmDescriptionCellIndex){
            AlarmDescriptionEditViewController *vc = [[AlarmDescriptionEditViewController alloc] init];
            vc.currentDesc = [_alarmDataSource getAlarmDescriptionInfo];
            vc.delegate = self;
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == AlarmSoundCellIndex){
            AlarmSoundSelectTableViewController *vc = [[AlarmSoundSelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.delegate = self;
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 界面初始化
-(void)setupNavigationBar {
    self.navigationItem.title = [_alarmDataSource getAlarmDataSourceDescriptionInfo];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickedCancelBtn:)];
    UIBarButtonItem *saveBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickedSaveBtn:)];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    self.navigationItem.rightBarButtonItem = saveBarBtn;
}

-(void)setupView {
    self.tableView.separatorColor = [ColorManager divColor];
    _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 167)];
    _datePickerView.datePickerMode = UIDatePickerModeTime;
    [_datePickerView setValue:[ColorManager mainTextColor] forKey:@"textColor"];
    [_datePickerView addTarget:self action:@selector(datePickerTimeChanged:) forControlEvents:UIControlEventValueChanged];
    self.tableView.tableHeaderView = _datePickerView;
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.alwaysBounceHorizontal = NO;
    [_remindLaterSwitch addTarget:self action:@selector(clickedRemindLaterSwitch:) forControlEvents:UIControlEventValueChanged];
    
    _alarmRepeatLabel.text = [_alarmDataSource getAlarmRepeatInfo];
    _alarmDescriptionLabel.text = [_alarmDataSource getAlarmDescriptionInfo];
    _alarmSoundLabel.text  = [_alarmDataSource getSoundDescriptionInfo];
    _remindLaterSwitch.on  = [_alarmDataSource getAlarmRemindLaterInfo];
    _datePickerView.date = [_alarmDataSource getAlarmDate];
}

@end
