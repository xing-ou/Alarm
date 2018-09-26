//
//  AlarmTableViewCell.h
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlarmTableViewCellDelegate <NSObject>

-(void)alarmTableViewCellClickedSwitchAtIndex:(NSInteger)index on:(BOOL)on;

@end

@interface AlarmTableViewCell : UITableViewCell

/** 时间 */
@property(nonatomic,strong)UILabel *alarmTimeLabel;
/** 描述 */
@property(nonatomic,strong)UILabel *alarmDescLabel;
/** 开关 */
@property(nonatomic,strong)UISwitch *alarmSwitch;

@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,weak)id<AlarmTableViewCellDelegate> delegate;
@end
