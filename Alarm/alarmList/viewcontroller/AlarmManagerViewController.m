//
//  AlarmManagerViewController.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmManagerViewController.h"
#import "ColorManager.h"
#import "AlarmTableViewCell.h"
#import <Masonry/Masonry.h>
#import "AlarmInfoTableViewController.h"
#import "AlarmNewInfoDataSource.h"
#import "AlarmEditInfoDataSource.h"
#import "AlarmNotifications.h"
#import "AlarmDAO.h"
#import "AlarmService.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface AlarmManagerViewController ()<UITableViewDelegate,UITableViewDataSource,AlarmTableViewCellDelegate>

@property (strong, nonatomic) UITableView *alarmTableView;

@property(nonatomic,strong)NSMutableArray *allAlarms;
@property(nonatomic,strong)NSDateFormatter *dateFormater;

@end

@implementation AlarmManagerViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    _allAlarms = [[NSMutableArray alloc] init];
    /** 界面初始化 */
    [self setupNavigationBar];
    [self setupView];
    [self addNotification];
    [self shouldReloadAlarmList:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [AlarmService shareInstance];
}
#pragma mark - 通知
-(void)shouldReloadAlarmList:(NSNotification *)notify {
    NSMutableArray *allAlarms = [[AlarmDAO getAllAlarms] mutableCopy];
    if(allAlarms.count == 0){
        UILabel *noAlarmLabel = [[UILabel alloc] init];
        noAlarmLabel.text = @"未设置闹钟";
        noAlarmLabel.font = [UIFont systemFontOfSize:28];
        noAlarmLabel.textAlignment = NSTextAlignmentCenter;
        noAlarmLabel.textColor = [ColorManager color0x666666];
        noAlarmLabel.frame = [self.alarmTableView bounds];
        self.alarmTableView.backgroundView = noAlarmLabel;
    }else{
        self.alarmTableView.backgroundView = nil;
    }
    self.allAlarms = allAlarms;
    [self.alarmTableView reloadData];
}

#pragma mark - 界面事件
-(void)clickedEditBarBtn:(UIBarButtonItem *)sender {
    [self.alarmTableView setEditing:!self.alarmTableView.editing animated:NO];
}

-(void)clickedAddAlarmBarBtn:(UIBarButtonItem *)sender {
    AlarmInfoTableViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([AlarmInfoTableViewController class])];
    vc.alarmDataSource = [[AlarmNewInfoDataSource alloc] initWithAlarmModel: [AlarmModel defaultModel]];
    UINavigationController *naviVc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naviVc animated:YES completion:nil];
}
#pragma mark - tableview相关
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allAlarms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AlarmTableViewCell class])];
    AlarmModel *model = self.allAlarms[indexPath.row];
    cell.alarmTimeLabel.attributedText = [self getTimeStrFromModel:model];
    cell.alarmDescLabel.text = [self getAlarmDescStrFromModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.currentIndex = indexPath.row;
    cell.alarmSwitch.on = model.isActive;
    if(cell.delegate == nil){
        cell.delegate = self;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.editing == NO){ return; }
    AlarmInfoTableViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([AlarmInfoTableViewController class])];
    vc.alarmDataSource = [[AlarmEditInfoDataSource alloc] initWithAlarmModel: self.allAlarms[indexPath.row]];
    UINavigationController *naviVc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naviVc animated:YES completion:nil];
    [tableView setEditing:NO animated:NO];
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf.alarmTableView setEditing:NO animated:YES];
        [weakSelf deleteAlarmAtIndex:indexPath.row];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction];
}

/** ios11之后需要用这个方法来定义左滑后显示的东西 */
-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(11_0){
    __weak typeof(self) weakSelf = self;
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [weakSelf deleteAlarmAtIndex:indexPath.row];
        completionHandler(YES);
    }];
    deleteAction.backgroundColor = [UIColor redColor];

    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    config.performsFirstActionWithFullSwipe = NO;//防止full swipe时自动执行删除操作
    return config;
}

-(void)deleteAlarmAtIndex:(NSInteger)index {
    AlarmModel *model = self.allAlarms[index];
    [AlarmDAO deleteAlarmWithAlarmId:model.alarmId];
    [self shouldReloadAlarmList:nil];
}

-(void)alarmTableViewCellClickedSwitchAtIndex:(NSInteger)index on:(BOOL)on {
    AlarmModel *model = self.allAlarms[index];
    if(on == YES){//重新开启
        [[AlarmService shareInstance] registAlarmWithModel:model];
    }else{//关闭
        [[AlarmService shareInstance] unregistAlarmWithModel:model];
    }
}
#pragma mark - 界面初始化
-(void)setupNavigationBar {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    self.navigationItem.title = @"闹钟";
    UIBarButtonItem *editBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(clickedEditBarBtn:)];
    self.navigationItem.leftBarButtonItem = editBarBtn;
    
    UIBarButtonItem *addAlarmBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickedAddAlarmBarBtn:)];
    self.navigationItem.rightBarButtonItem = addAlarmBarBtn;
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
    div.backgroundColor = [ColorManager divColor];
    [navigationBar addSubview:div];
    [div mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(navigationBar);
        make.trailing.mas_equalTo(navigationBar);
        make.bottom.mas_equalTo(navigationBar);
        make.height.mas_equalTo(0.5);
    }];
}

-(void)setupView {
    self.view.backgroundColor = [ColorManager mainBackgroundColor];
    _alarmTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_alarmTableView registerClass:[AlarmTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AlarmTableViewCell class])];
    _alarmTableView.rowHeight = 100;
    _alarmTableView.backgroundColor = [ColorManager mainBackgroundColor];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _alarmTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.1)];
    _alarmTableView.delegate = self;
    _alarmTableView.dataSource = self;
    _alarmTableView.separatorColor = [ColorManager divColor];
    _alarmTableView.allowsSelectionDuringEditing = YES;
    [self.view addSubview:_alarmTableView];
    _alarmTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [_alarmTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

-(void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReloadAlarmList:) name:AlarmListShouldReloadNotification object:nil];
}

#pragma mark - 辅助方法
-(NSAttributedString *)getTimeStrFromModel:(AlarmModel *)model {
    if(_dateFormater == nil){
        _dateFormater = [[NSDateFormatter alloc] init];
        _dateFormater.dateFormat = @"H h:mm";
    }
    NSString *dateStr = [_dateFormater stringFromDate:model.alarmTime];
    NSArray *times = [dateStr componentsSeparatedByString:@" "];
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] init];
    if([times.firstObject intValue] >= 12){
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"下午" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:27]}];
        [result appendAttributedString:attrStr];
    }else{
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"上午" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:27]}];
        [result appendAttributedString:attrStr];
    }
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:times.lastObject attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50]}];
    [result appendAttributedString:attrStr];
    return result;
}

-(NSString *)getAlarmDescStrFromModel:(AlarmModel *)model {
    NSString *result = model.alarmDescription;
    if(model.repeat != 0){
        result = [NSString stringWithFormat:@"%@,%@",result,[model getRepeatDescription]];
    }
    return result;
}


@end
