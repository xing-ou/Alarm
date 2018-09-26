//
//  AlarmInfoDataSource.h
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmModel.h"
/** 代表闹钟信息界面的数据源 */
@interface AlarmInfoDataSource : NSObject

-(instancetype)initWithAlarmModel:(AlarmModel *)alarmModel;

@property(nonatomic,strong)AlarmModel *alarmModel;

/** 保存和删除闹钟信息 */
-(void)saveAlarm;
-(void)deleteAlarm;
-(int)sectionNum;

/** 获取数据 */
-(NSDate *)getAlarmDate;
-(NSString *)getAlarmDataSourceDescriptionInfo;
-(NSString *)getAlarmRepeatInfo;
-(NSString *)getAlarmDescriptionInfo;
-(NSString *)getSoundDescriptionInfo;
-(BOOL)getAlarmRemindLaterInfo;

/** 设置数据 */
-(void)setAlarmRepeatDays:(NSArray *)repeateDays;
-(void)setAlarmDescription:(NSString *)des;
-(void)setAlarmSoundPath:(NSString *)path;
-(void)setAlarmRemindLater:(BOOL)remindLater;

@end
