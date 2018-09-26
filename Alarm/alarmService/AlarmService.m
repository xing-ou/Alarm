//
//  AlarmService.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmService.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "AlarmDAO.h"
#import "AlarmNotifications.h"
#import "AlarmCloseViewController.h"
@interface AlarmService()<UNUserNotificationCenterDelegate>

@property(nonatomic,strong)NSDateFormatter *dateFormatter;

@end


@implementation AlarmService

+(instancetype)shareInstance  {
    static  AlarmService * share = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        if (!share) {
            share = [[AlarmService alloc] init];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = share;
            share.dateFormatter = [[NSDateFormatter alloc] init];
            share.dateFormatter.dateFormat = @"h:mm";
        }
    });
    return share;
}

/** 稍后提醒一个闹钟 */
-(void)remindLaterAlarmWithModel:(AlarmModel *)model {
    //重新创建通知就行
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"ALARM";
    NSString *dateStr = [_dateFormatter stringFromDate:model.alarmTime];
    content.body = [NSString stringWithFormat:@"%@,%@,已提醒%d次",model.alarmDescription,dateStr,model.remindCount+1];
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{@"alarmId":model.alarmId};
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    NSArray *times = [[self.dateFormatter stringFromDate:model.alarmTime] componentsSeparatedByString:@":"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitHour |NSCalendarUnitMinute  ;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60 * 2];
    comps = [calendar components:unitFlags fromDate:date];
    NSLog(@"time1 ==>%@",date);
    UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:comps repeats:NO];
    NSLog(@"time2 ==>%@",[calendarTrigger nextTriggerDate]);
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:model.alarmId content:content trigger:calendarTrigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
        NSLog(@"成功添加推送");
    }];
}

/** 注册一个闹钟 */
-(void)registAlarmWithModel:(AlarmModel *)model {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = model.alarmDescription;
    content.sound = [UNNotificationSound defaultSound];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    NSString *dateStr = [self.dateFormatter stringFromDate:model.alarmTime];
    content.body = [NSString stringWithFormat:@"%@,%@,已提醒%d次",model.alarmDescription,dateStr,model.remindCount+1];
    NSArray *times = [dateStr componentsSeparatedByString:@":"];
    
    UNCalendarNotificationTrigger *calendarTrigger = nil;
    if(model.repeat == 0){
        content.userInfo = @{@"alarmId":model.alarmId};
        NSCalendar *calendar = [NSCalendar currentCalendar];
        calendar.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        NSDateComponents* comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitHour |NSCalendarUnitMinute  ;
        comps = [calendar components:unitFlags fromDate:model.alarmTime];
        UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:comps repeats:NO];
        NSLog(@"%@",[calendarTrigger nextTriggerDate]);
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:model.alarmId content:content trigger:calendarTrigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"成功添加推送");
        }];
    }else{
        for (int i = 0; i < 7; i++) {
            if(model.repeat & (1<<i)){
                content.userInfo = @{@"alarmId":model.alarmId,@"week":@(i+1)};
                NSCalendar *calendar = [NSCalendar currentCalendar];
                calendar.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
                NSDateComponents* comps = [[NSDateComponents alloc] init];
                NSInteger unitFlags = NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute  ;
                comps = [calendar components:unitFlags fromDate:model.alarmTime];
                int weekday = 1;
                switch (i) {
                    case 0: weekday = 2;break;//星期一
                    case 1: weekday = 3;break;
                    case 2: weekday = 4;break;
                    case 3: weekday = 5;break;
                    case 4: weekday = 6;break;
                    case 5: weekday = 7;break;
                    case 6: weekday = 1;break;
                    default:break;
                }
                comps.weekday = weekday;
                UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:comps repeats:YES];
                NSLog(@"%@",[calendarTrigger nextTriggerDate]);
                NSString *requestId = [NSString stringWithFormat:@"%@%d",model.alarmId,i+1];
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestId content:content trigger:calendarTrigger];
                [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
                    NSLog(@"成功添加推送");
                }];
            }
        }

    }
}

/** 关闭一个闹钟 */
-(void)closeAlarmWithModel:(AlarmModel *)model {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    if(model.repeat == 0){//不重复的，关闭后就是未active的
        /** 置为un active */
        model.remindCount = 0;
        model.isActive = NO;
        [AlarmDAO insertOrReplaceAlarm:model];
        [center removePendingNotificationRequestsWithIdentifiers:@[model.alarmId]];
    }else{//重复的，关闭，只用把稍后提醒的闹钟给关闭就行
        model.remindCount = 0;
        [AlarmDAO insertOrReplaceAlarm:model];
        [center removePendingNotificationRequestsWithIdentifiers:@[model.alarmId]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AlarmListShouldReloadNotification object:nil];
}
/** 取消注册一个闹钟 */
-(void)unregistAlarmWithModel:(AlarmModel *)model {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    /** 置为un active */
    model.remindCount = 0;
    model.isActive = NO;
    [AlarmDAO insertOrReplaceAlarm:model];
    if(model.repeat == 0){//不重复的，那么将闹钟的active置为NO，并从本地通知中移除
        [center removePendingNotificationRequestsWithIdentifiers:@[model.alarmId]];
    }else{
        NSMutableArray *requestIds = [[NSMutableArray alloc] init];
        [requestIds addObject:model.alarmId];
        for (int i = 0; i < 7; i++) {
            NSString *requestId = [NSString stringWithFormat:@"%@%d",model.alarmId,i+1];
            [requestIds addObject:requestId];
        }
        [center removePendingNotificationRequestsWithIdentifiers:requestIds];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AlarmListShouldReloadNotification object:nil];
}

/** 删除一个闹钟 */
-(void)deleteAlarmWithModel:(AlarmModel *)model {
    [self unregistAlarmWithModel:model];
    [AlarmDAO deleteAlarmWithAlarmId:model.alarmId];
    [[NSNotificationCenter defaultCenter] postNotificationName:AlarmListShouldReloadNotification object:nil];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    NSDictionary * userInfo = request.content.userInfo;
    NSString *alarmId = userInfo[@"alarmId"];
    AlarmModel *model = [AlarmDAO getAlarmById:alarmId];
    
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    AlarmCloseViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlarmCloseViewController"];
    vc.model = model;
    [rootVc presentViewController:vc animated:YES completion:nil];
    //completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}


@end
