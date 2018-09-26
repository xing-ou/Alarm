//
//  AlarmService.h
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmModel.h"
/** 负责闹钟的注册，销毁等 */
@interface AlarmService : NSObject

+(instancetype)shareInstance;

/** 注册一个闹钟 */
-(void)registAlarmWithModel:(AlarmModel *)model;
/** 稍后提醒一个闹钟 */
-(void)remindLaterAlarmWithModel:(AlarmModel *)model;
/** 关闭一个闹钟 */
-(void)closeAlarmWithModel:(AlarmModel *)model;
/** 取消注册一个闹钟 */
-(void)unregistAlarmWithModel:(AlarmModel *)model;
/** 删除一个闹钟 */
-(void)deleteAlarmWithModel:(AlarmModel *)model;

@end
