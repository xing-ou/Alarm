//
//  AlarmModel+WCTTableCoding.h
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmModel.h"
#import <WCDB/WCDB.h>

@interface AlarmModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(alarmId)
WCDB_PROPERTY(alarmTime)
WCDB_PROPERTY(repeat)
WCDB_PROPERTY(alarmDescription)
WCDB_PROPERTY(alarmSoundPath)
WCDB_PROPERTY(remindLater)
WCDB_PROPERTY(isActive)
WCDB_PROPERTY(remindCount)

@end
