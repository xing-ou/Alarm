//
//  AlarmDescriptionEditViewController.h
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AlarmDescriptionEditViewControllerDelegate <NSObject>

-(void)alarmDescriptionDidChange:(NSString *)desc;

@end


@interface AlarmDescriptionEditViewController : UIViewController

@property(nonatomic,weak)id <AlarmDescriptionEditViewControllerDelegate> delegate;

@property(nonatomic,copy)NSString *currentDesc;

@end
