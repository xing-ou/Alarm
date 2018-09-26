//
//  WeekDaySelectViewController.h
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeekDaySelectViewControllerDelegate <NSObject>

-(void)weekDayDidSelect:(NSArray *)days;

@end

/** 星期选择viewcontroller */
@interface WeekDaySelectViewController : UITableViewController

@property(nonatomic,weak)id<WeekDaySelectViewControllerDelegate> delegate;

@end
