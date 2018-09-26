//
//  AlarmSoundSelectTableViewController.h
//  Alarm
//
//  Created by 苟欣 on 2018/9/23.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlarmSoundSelectTableViewControllerDelegate <NSObject>

-(void)alarmSoundSelectDidSelectAtPath:(NSString *)path;

@end

/** 铃声选择 */
@interface AlarmSoundSelectTableViewController : UITableViewController

@property(nonatomic,weak)id <AlarmSoundSelectTableViewControllerDelegate> delegate;

@end
