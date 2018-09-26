//
//  WeekDaySelectViewController.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "WeekDaySelectViewController.h"
#import "ColorManager.h"
@interface WeekDaySelectViewController ()

@property(nonatomic,strong)NSArray *allDays;
@property(nonatomic,strong)NSMutableSet *selectedDays;

@end

@implementation WeekDaySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    _allDays = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    _selectedDays = [[NSMutableSet alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [ColorManager mainBackgroundColor];
    cell.contentView.backgroundColor = [ColorManager mainBackgroundColor];
    cell.textLabel.text = _allDays[indexPath.row];
    cell.textLabel.textColor = [ColorManager mainTextColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([_selectedDays containsObject:@(indexPath.row)]){
        [_selectedDays removeObject:@(indexPath.row)];
        cell.accessoryView = nil;
    }else{
        [_selectedDays addObject:@(indexPath.row)];
        cell.accessoryView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"selected"]];
    }
    if(_delegate != nil){
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (NSNumber *index in _selectedDays) {
            [result addObject:index];
        }
        [_delegate weekDayDidSelect:result];
    }
}

#pragma mark - 界面初始化
-(void)setupView {
    self.navigationItem.title = @"重复";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.rowHeight = 44;
    self.view.backgroundColor = [ColorManager mainBackgroundColor];
    self.tableView.backgroundColor = [ColorManager mainBackgroundColor];
    self.tableView.separatorColor = [ColorManager divColor];
}


@end
