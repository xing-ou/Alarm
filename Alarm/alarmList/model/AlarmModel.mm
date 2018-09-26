//
//  AlarmModel.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmModel.h"
#import <WCDB/WCDB.h>

@implementation AlarmModel

WCDB_IMPLEMENTATION(AlarmModel)
WCDB_SYNTHESIZE(AlarmModel, alarmId)
WCDB_SYNTHESIZE(AlarmModel, alarmTime)
WCDB_SYNTHESIZE(AlarmModel, repeat)
WCDB_SYNTHESIZE(AlarmModel, alarmDescription)
WCDB_SYNTHESIZE(AlarmModel, alarmSoundPath)
WCDB_SYNTHESIZE(AlarmModel, remindLater)
WCDB_SYNTHESIZE(AlarmModel, isActive)
WCDB_SYNTHESIZE(AlarmModel, remindCount)


WCDB_PRIMARY(AlarmModel, alarmId)

+(AlarmModel *)defaultModel {
    AlarmModel *model = [[AlarmModel alloc] init];
    model.alarmId = [[NSUUID UUID] UUIDString];
    model.alarmTime = [NSDate date];
    model.repeat = 0;
    model.alarmDescription = @"闹钟";
    model.alarmSoundPath = @"/Library/Ringtones/Beacon.m4r";
    model.remindLater = YES;
    model.isActive = NO;
    model.remindCount = 0;
    return model;
}


-(NSString *)getRepeatDescription {
    NSMutableArray *times = [[NSMutableArray alloc] init];
    NSArray *days = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    for(int i = 0;i < 7;i++){
        if(self.repeat & (1 << i)){
            [times addObject:days[i]];
        }
    }
    if(times.count == 0){
        return @"永不";
    }
    if(times.count == days.count){
        return @"每天";
    }
    return [times componentsJoinedByString:@","];
}

@end
