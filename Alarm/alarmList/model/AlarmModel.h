//
//  AlarmModel.h
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 代表一个闹钟 */
@interface AlarmModel : NSObject

/** alarm id */
@property(nonatomic,copy)NSString *alarmId;
/** 闹钟时间 */
@property(nonatomic,strong)NSDate *alarmTime;
/** 是否重复,低7个bit,为1代表周几重复*/
@property(nonatomic,assign)int repeat;
/** 闹钟描述 */
@property(nonatomic,copy)NSString *alarmDescription;
/** 铃声路径 */
@property(nonatomic,copy)NSString *alarmSoundPath;
/** 稍后提醒 */
@property(nonatomic,assign)BOOL remindLater;
/** 是否生效 */
@property(nonatomic,assign)BOOL isActive;
/** 总的提醒次数 */
@property(nonatomic,assign)int remindCount;

+(AlarmModel *)defaultModel;
-(NSString *)getRepeatDescription;

@end
