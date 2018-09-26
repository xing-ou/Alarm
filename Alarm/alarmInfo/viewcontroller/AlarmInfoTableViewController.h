//
//  AlarmInfoTableViewController.h
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmInfoDataSource.h"
/** 闹钟信息界面 */
@interface AlarmInfoTableViewController : UITableViewController

@property(nonatomic,strong)AlarmInfoDataSource *alarmDataSource;

@end
