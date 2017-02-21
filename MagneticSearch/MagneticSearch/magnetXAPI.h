//
//  magnetXAPI.h
//  magnetX
//
//  Created by xiaxia on 16/10/22.
//  Copyright © 2016年 728599123@qq.com. All rights reserved.
//

#ifndef magnetXAPI_h
#define magnetXAPI_h

#define MagnetXSiteChangeNotification @"siteChangeNotification"
#define MagnetXSiteChangeKeywordNotification @"siteChangeKeywordNotification"
#define MagnetXStartAnimatingProgressIndicator @"startAnimatingProgressIndicator"
#define MagnetXStopAnimatingProgressIndicator @"stopAnimatingProgressIndicator"
#define MagnetXUpdateRuleNotification @"UpdateRuleNotification"
#define MagnetXMakeFirstResponder   @"makeFirstResponder"


#define MagnetXUpdateAppURL     @"https://github.com/youusername/magnetX/releases"

#define MagnetXVersionString     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define MagnetXBundleName     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define RGB(a,b,c) [UIColor colorWithRed:(a/255.0) green:(b/255.0) blue:(c/255.0) alpha:1.0]

#define RGBA(a,b,c,d) [UIColor colorWithRed:(a/255.0) green:(b/255.0) blue:(c/255.0) alpha:d]

#pragma mark - Snippet
#define WEAKSELF(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define STRONGSELF(o) autoreleasepool{} __strong typeof(o) o = o##Weak;



#define Lantinghei(s) [UIFont fontWithName:@"Lantinghei SC" size:s]
#define LantingheiBold(s) [UIFont fontWithName:@"FZLTHJW--GB1-0" size:s]
#define LantingheiBoldS(s) [UIFont fontWithName:@"FZLanTingHeiS-B-GB" size:s]


#endif /* magnetXAPI_h */
