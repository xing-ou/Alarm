//
//  AlarmCloseViewController.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "AlarmCloseViewController.h"
#import "ColorManager.h"
#import "AlarmService.h"
#import <AudioToolbox/AudioToolbox.h>
@interface AlarmCloseViewController ()

@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *remindLaterBtn;

@property(nonatomic,strong)NSDateFormatter *dateFormatter;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)SystemSoundID soundID;

@end

@implementation AlarmCloseViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"h:mm";
    AudioServicesCreateSystemSoundID((__bridge CFURLRef )([NSURL fileURLWithPath:_model.alarmSoundPath]), &_soundID);
    [self setupView];
    [self setupTimer];
    [self playSounds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 界面事件

- (IBAction)clickedCloseAlarmBtn:(UIButton *)sender {
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
    [self stopPlaySound];
    [[AlarmService shareInstance] closeAlarmWithModel:_model];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickedRemindLaterBtn:(UIButton *)sender {
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
    [self stopPlaySound];
    [[AlarmService shareInstance] remindLaterAlarmWithModel:_model];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 定时器
//一分钟到达，开启一个新的本地通知
-(void)oneMinArrive {
    [_timer invalidate];
    _timer = nil;
    [self clickedRemindLaterBtn:nil];
}

#pragma mark - 初始化
-(void)setupView {
    NSString *timeStr = [_dateFormatter stringFromDate:_model.alarmTime];
    _alarmTimeLabel.text = [NSString stringWithFormat:@"闹钟时间:%@",timeStr];
    if(_model.remindCount >  0){
        _alarmCountLabel.text = [NSString stringWithFormat:@"已提醒 %d 次",_model.remindCount];
        _alarmCountLabel.hidden = NO;
    }else{
        _alarmCountLabel.hidden = YES;
    }
    if(_model.remindLater == NO){
        _remindLaterBtn.hidden = YES;
    }
}

-(void)setupTimer {
    if(_model.remindLater == YES){//如果设置了稍后提示，那么设个定时器，1分钟后，暂停，2分钟后重新提醒
        _timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(oneMinArrive) userInfo:nil repeats:NO];
    }else{//一直提醒
        [self playSounds];
    }
    
}

-(void)playSounds {
    __weak typeof(self) weakSelf = self;
    AudioServicesPlaySystemSoundWithCompletion(_soundID, ^{
        if(weakSelf.timer != nil){
            [weakSelf playSounds];
        }
    });
}

-(void)stopPlaySound {
    AudioServicesDisposeSystemSoundID(_soundID);
}

@end
