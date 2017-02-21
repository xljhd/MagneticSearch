//
//  MagnetsCellTableViewCell.h
//  MagneticApp
//
//  Created by xiaxia on 2016/11/27.
//  Copyright © 2016年 xiaxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "movieModel.h"

@interface MagnetsCellTableViewCell : UITableViewCell
@property (nonatomic,strong)movieModel *model;
@property (nonatomic,strong)NSString *movieName;
@end
