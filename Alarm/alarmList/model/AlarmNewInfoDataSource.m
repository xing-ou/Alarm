//
//  AlarmNewInfoDataSource.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmNewInfoDataSource.h"
#import "AlarmDAO.h"
@implementation AlarmNewInfoDataSource

/** 保存和删除闹钟信息 */
-(void)saveAlarm {
    self.alarmModel.isActive = YES;
    [AlarmDAO insertOrReplaceAlarm:self.alarmModel];
}

-(void)deleteAlarm {
    
}

-(int)sectionNum {
    return 1;
}

/** 获取数据 */
-(NSString *)getAlarmDataSourceDescriptionInfo {
    return @"新建闹钟";
}

@end
