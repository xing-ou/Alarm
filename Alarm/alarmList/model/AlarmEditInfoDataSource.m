//
//  AlarmEditInfoDataSource.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmEditInfoDataSource.h"
#import "AlarmDAO.h"
@implementation AlarmEditInfoDataSource



/** 保存和删除闹钟信息 */
-(void)saveAlarm {
    self.alarmModel.isActive = YES;
    [AlarmDAO insertOrReplaceAlarm:self.alarmModel];
}

-(void)deleteAlarm {
    [AlarmDAO deleteAlarmWithAlarmId:self.alarmModel.alarmId];
}

-(int)sectionNum {
    return 2;
}

/** 获取数据 */
-(NSString *)getAlarmDataSourceDescriptionInfo {
    return @"编辑闹钟";
}


@end
