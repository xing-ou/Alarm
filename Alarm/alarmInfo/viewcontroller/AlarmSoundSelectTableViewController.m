//
//  AlarmSoundSelectTableViewController.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmSoundSelectTableViewController.h"
#import "ColorManager.h"
@interface AlarmSoundSelectTableViewController ()

@property(nonatomic,strong)NSMutableArray *allSounds;
@property(nonatomic,assign)NSInteger currentSelectIndex;

@end

@implementation AlarmSoundSelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentSelectIndex = -1;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.rowHeight = 50;
    self.tableView.separatorColor = [ColorManager divColor];
    self.navigationItem.title = @"铃声";
    self.view.backgroundColor = [ColorManager mainBackgroundColor];
    self.tableView.backgroundColor = [ColorManager mainBackgroundColor];
    _allSounds = [[NSMutableArray alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = @"/Library/Ringtones";
    
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSString *fileName;
    NSMutableDictionary *R = [NSMutableDictionary dictionary];
    while (fileName = [dirEnum nextObject]) {
        [_allSounds addObject:[path stringByAppendingPathComponent:fileName]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allSounds.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [_allSounds[indexPath.row] lastPathComponent];
    cell.backgroundColor = [ColorManager mainBackgroundColor];
    cell.contentView.backgroundColor = [ColorManager mainBackgroundColor];
    cell.textLabel.textColor = [ColorManager mainTextColor];
    if(indexPath.row == _currentSelectIndex){
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
    }else{
        cell.accessoryView = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_currentSelectIndex >= 0){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectIndex inSection:0]];
        if(cell != nil){
            cell.accessoryView = nil;
        }
    }
    _currentSelectIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell != nil){
        cell.accessoryView = cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
    }
    if(_delegate != nil){
        [_delegate alarmSoundSelectDidSelectAtPath:_allSounds[indexPath.row]];
    }
}

@end
