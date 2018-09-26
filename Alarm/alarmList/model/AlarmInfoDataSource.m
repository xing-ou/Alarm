//
//  AlarmInfoDataSource.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmInfoDataSource.h"



@implementation AlarmInfoDataSource

-(instancetype)initWithAlarmModel:(AlarmModel *)alarmModel {
    self = [super init];
    if(self != nil){
        _alarmModel = alarmModel;
    }
    return self;
}

/** 保存和删除闹钟信息 */
-(void)saveAlarm {
    
}

-(void)deleteAlarm {
    
}

-(int)sectionNum {
    return 0;
}

/** 获取数据 */
-(NSDate *)getAlarmDate {
    return _alarmModel.alarmTime;
}

-(NSString *)getAlarmDataSourceDescriptionInfo {
    return @"";
}

-(NSString *)getSoundDescriptionInfo {
    return [self.alarmModel.alarmSoundPath lastPathComponent];
}

-(NSString *)getAlarmRepeatInfo {
    return [self.alarmModel getRepeatDescription];
}

-(NSString *)getAlarmDescriptionInfo {
    return _alarmModel.alarmDescription;
}

-(BOOL)getAlarmRemindLaterInfo {
    return _alarmModel.remindLater;
}

/** 设置数据 */
-(void)setAlarmRepeatDays:(NSArray *)repeateDays {
    int result = 0;
    for (NSNumber *day in repeateDays) {
        result |= (1 << [day intValue]);
    }
    _alarmModel.repeat = result;
}

-(void)setAlarmDescription:(NSString *)des {
    _alarmModel.alarmDescription = des;
}

-(void)setAlarmSoundPath:(NSString *)path {
    _alarmModel.alarmSoundPath = path;
}

-(void)setAlarmRemindLater:(BOOL)remindLater {
    _alarmModel.remindLater = remindLater;
}



@end
