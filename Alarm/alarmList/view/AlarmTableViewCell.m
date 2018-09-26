//
//  AlarmTableViewCell.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmTableViewCell.h"
#import <Masonry/Masonry.h>
#import "ColorManager.h"

@implementation AlarmTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil){
        self.backgroundColor = [ColorManager mainBackgroundColor];
        self.contentView.backgroundColor = [ColorManager mainBackgroundColor];
        _alarmTimeLabel = [[UILabel alloc] init];
        _alarmTimeLabel.text = @"12:00";
        _alarmTimeLabel.font = [UIFont boldSystemFontOfSize:35];
        _alarmTimeLabel.textColor = [ColorManager mainTextColor];
        _alarmTimeLabel.backgroundColor = [ColorManager mainBackgroundColor];
        [self.contentView addSubview:_alarmTimeLabel];
        [_alarmTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView).offset(20);
            make.top.mas_equalTo(self.contentView).offset(10);
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(200);
        }];
        
        _alarmDescLabel = [[UILabel alloc] init];
        _alarmDescLabel.text = @"12:00";
        _alarmDescLabel.font = [UIFont boldSystemFontOfSize:17];
        _alarmDescLabel.textColor = [ColorManager mainTextColor];
        _alarmDescLabel.backgroundColor = [ColorManager mainBackgroundColor];
        [self.contentView addSubview:_alarmDescLabel];
        [_alarmDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView).offset(20);
            make.top.mas_equalTo(self.alarmTimeLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(25);
            make.trailing.mas_equalTo(self.contentView);
        }];
        
        
        _alarmSwitch = [[UISwitch alloc] init];
        _alarmSwitch.on = NO;
        [self.contentView addSubview:_alarmSwitch];
        [_alarmSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.contentView).offset(-30);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [_alarmSwitch addTarget:self action:@selector(clickedSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)clickedSwitch:(UISwitch *)sender {
    if(_delegate != nil){
        [_delegate alarmTableViewCellClickedSwitchAtIndex:_currentIndex on:sender.on];
    }
}

@end
