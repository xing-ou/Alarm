//
//  AlarmDAO.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmDAO.h"
#import "AlarmModel+WCTTableCoding.h"
@implementation AlarmDAO


+(void)deleteAlarmWithAlarmId:(NSString *)alarmId {
    WCTTable *table = [self getTable];
    [table deleteObjectsWhere:AlarmModel.alarmId == alarmId];
}

+(AlarmModel *)getAlarmById:(NSString *)alarmId {
    WCTTable *table = [self getTable];
    AlarmModel *model = [[table getObjectsWhere:AlarmModel.alarmId == alarmId ] firstObject];
    return model;
}

+(void)insertOrReplaceAlarm:(AlarmModel *)alarmModel {
    WCTTable *table = [self getTable];
    [table insertOrReplaceObject:alarmModel];
}

+(NSArray <AlarmModel *> *)getAllAlarms {
    WCTTable *table = [self getTable];
    NSArray <AlarmModel *> *result = [table getAllObjects];
    return result;
}

+(WCTTable *)getTable {
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [NSString stringWithFormat:@"%@/db/%@",documentDir,@"alarm"];
    WCTDatabase *dataBase = [[WCTDatabase alloc] initWithPath:dbPath];
    [dataBase createTableAndIndexesOfName:NSStringFromClass([AlarmModel class]) withClass:[AlarmModel class]];
    WCTTable * table = [dataBase getTableOfName:NSStringFromClass([AlarmModel class]) withClass:[AlarmModel class]];
    return table;
}


@end
