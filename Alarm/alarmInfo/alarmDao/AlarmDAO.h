//
//  AlarmDAO.h
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmModel.h"
/** 数据库获取对象 */
@interface AlarmDAO : NSObject

+(void)insertOrReplaceAlarm:(AlarmModel *)alarmModel;
+(NSArray <AlarmModel *> *)getAllAlarms;
+(AlarmModel *)getAlarmById:(NSString *)alarmId;
+(void)deleteAlarmWithAlarmId:(NSString *)alarmId;

@end
