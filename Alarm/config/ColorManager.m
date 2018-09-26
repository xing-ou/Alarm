//
//  ColorManager.m
//  Alarm
//
//  Created by 苟欣 on 2018/9/22.
//  Copyright © 2018年 苟欣. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager


/** 导航栏的tintcolor */
+(UIColor *)navigationTintColor {
    return [UIColor colorWithRed:0xf8/255.0 green:0x9d/255.0 blue:0x39/255.0 alpha:1.0];
}
/** 主文字color */
+(UIColor *)mainTextColor {
    return [UIColor whiteColor];
}
/** 主背景color */
+(UIColor *)mainBackgroundColor {
    return [UIColor blackColor];
}
/** 分割线 */
+(UIColor *)divColor {
    return [UIColor colorWithRed:0x44/255.0 green:0x44/255.0 blue:0x44/255.0 alpha:1.0];
}

+(UIColor *)color0x666666 {
    return [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
}
@end
