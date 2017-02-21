//
//  RemindCell.m
//  MagneticApp
//
//  Created by xiaxia on 2016/11/28.
//  Copyright © 2016年 xiaxia. All rights reserved.
//

#import "RemindCell.h"

@implementation RemindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleLab];
        self.titleLab.sd_layout
        .leftSpaceToView(self.contentView,5)
        .centerYEqualToView(self.contentView)
        .heightIs(22);
        
        [self.titleLab setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
    }
    
    return self;
}

- (void)setModel:(movieModel *)model {
    
    _model = model;
    [self setupAutoHeightWithBottomView:self.titleLab bottomMargin:0];
}

- (UILabel *)titleLab {
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"注：本站仅提供搜索，不做任何存储跟保留";
        _titleLab.font = Lantinghei(10);
    }
    return _titleLab;
}
@end
