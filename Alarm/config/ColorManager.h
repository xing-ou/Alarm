//
//  ColorManager.h
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/** 色彩管理 */
@interface ColorManager : NSObject
/** 导航栏的tintcolor */
+(UIColor *)navigationTintColor;
/** 主文字color */
+(UIColor *)mainTextColor;
/** 主背景color */
+(UIColor *)mainBackgroundColor;
/** 分割线 */
+(UIColor *)divColor;

+(UIColor *)color0x666666;
@end
