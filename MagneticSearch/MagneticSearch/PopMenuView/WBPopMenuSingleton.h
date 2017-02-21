//
//  WBPopMenuSingleton.h
//  QQ_PopMenu_Demo
//
//  Created by Transuner on 16/3/17.
//  Copyright © 2016年 吴冰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WBPopMenuSingleton : NSObject

/** 创建单例
 *
 *
 */
+ (WBPopMenuSingleton *) shareManager;


/** 创建一个弹出菜单
 *
 */
- (void) showPopMenuSelecteWithFrame:(CGFloat)width
                                item:(NSArray *)item
                              action:(void(^)(NSInteger index))action;

/** 隐藏菜单
 *
 *
 */
- (void) hideMenu;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
