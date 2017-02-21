//
//  MagnetsCellTableViewCell.m
//  MagneticApp
//
//  Created by xiaxia on 2016/11/27.
//  Copyright © 2016年 xiaxia. All rights reserved.
//

#define DetailFontSize 12
#define titleFontSize 15


#import "MagnetsCellTableViewCell.h"

@interface MagnetsCellTableViewCell()
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *descLab;
@property (nonatomic,strong)UILabel *sizeLab;
@property (nonatomic,strong)UILabel *dateLab;
@property (nonatomic,strong)UILabel *dateDetailLab;
@property (nonatomic,strong) UIImageView *magneticCopyImage;
@end

@implementation MagnetsCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.descLab];
        [self.contentView addSubview:self.sizeLab];
        [self.contentView addSubview:self.dateLab];
        [self.contentView addSubview:self.dateDetailLab];
        [self.contentView addSubview:self.magneticCopyImage];


        
        self.backgroundColor = RGB(247, 247, 247);
        
        self.titleLab.sd_layout
        .heightIs(22)
        .topSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,10);
        
       
        
        self.sizeLab.sd_layout
        .heightIs(22)
        .topSpaceToView(self.titleLab,5)
        .leftSpaceToView(self.contentView,10);
        [self.sizeLab setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
        
        self.descLab.sd_layout
        .heightIs(22)
        .topSpaceToView(self.titleLab,5)
        .leftSpaceToView(self.sizeLab,5);
        [self.descLab setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];

        
        self.dateLab.sd_layout
        .heightIs(22)
        .topEqualToView(self.sizeLab)
        .leftSpaceToView(self.descLab,10);
        [self.dateLab setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
        
        self.dateDetailLab.sd_layout
        .heightIs(22)
        .topEqualToView(self.sizeLab)
        .leftSpaceToView(self.dateLab,0);
        [self.dateDetailLab setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
        
        self.magneticCopyImage.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView,10)
        .widthIs(27/2)
        .heightIs(31/2);

    }
    
    return self;
}
- (void)setModel:(movieModel *)model {
    
    _model = model;
    if (_model.isShow) {
        self.titleLab.textColor = [UIColor darkGrayColor];
        self.sizeLab.textColor = [UIColor darkGrayColor];
        self.dateLab.textColor = [UIColor darkGrayColor];
        self.titleLab.text =  _model.name;

    }else {
        self.titleLab.attributedText = [self attributePage:_model.name];
    }
    
    
    self.descLab.text = _model.size;
    self.dateDetailLab.text = _model.count;

    [self setupAutoHeightWithBottomView:self.sizeLab bottomMargin:10];
}

- (void)setMovieName:(NSString *)movieName {
    _movieName = movieName;
}

- (NSMutableAttributedString*)attributePage:(NSString*)str{
    
 
    NSMutableAttributedString* ret = [[NSMutableAttributedString alloc] initWithString:str];
    if (self.movieName == nil) {
        return ret;
    }
    NSRange r = NSMakeRange(0, 0);
//    NSString *temp = nil;
//    NSString *sub = nil;
//    for(int i =0; i < [str length]; i++)
//    {
//        temp = [str substringWithRange:NSMakeRange(i, 1)];
//        
//        for (int j = 0; j < self.movieName.length; j++) {
//            sub = [self.movieName substringWithRange:NSMakeRange(j, 1)];
//            if ([temp isEqualToString:sub]) {
//                r.location = i;
//                r.length = self.movieName.length;
//                break;
//            }
//
//        }
//        
//      if ([temp isEqualToString:sub]) {
//          break;
//        }
//    }
    //先检测是否包含这个名字，如果包含再走下面的方法即可
    
    if ([str rangeOfString:self.movieName].location != NSNotFound) {
        
        NSArray *rangeArray = [self rangeOfSubString:self.movieName inString:str];
        NSUInteger location = 0;
        NSUInteger length = 0;
        for (int i = 0; i<rangeArray.count; i++) {
            r = NSRangeFromString(rangeArray[i]);
            location = r.location;
            length = r.length;
            if (location + length < str.length) {
                [ret addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:r];
            }
        }
        
    }
    

  
    return ret;
}


- (NSArray *)rangeOfSubString:(NSString *)subStr inString:(NSString *)string {
    
    NSMutableArray *rangeArray = [NSMutableArray array];
    
    NSString *string1 = [string stringByAppendingString:subStr];
    
    NSString *temp;
    
    for (int i = 0; i < string.length; i ++) {
        
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        
        if ([temp isEqualToString:subStr]) {
            
            NSRange range = {i,subStr.length};
            
            [rangeArray addObject:NSStringFromRange(range)];
            
        }
        
    }
    
    return rangeArray;
    
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = LantingheiBold(titleFontSize);
    }
    return _titleLab;
    
}

- (UILabel *)descLab {
    if (!_descLab) {
        _descLab = [UILabel new];
        _descLab.font = Lantinghei(DetailFontSize);
        _descLab.textColor = RGB(255, 136, 29);
    }
    return _descLab;
    
}

- (UILabel *)sizeLab {
    if (!_sizeLab) {
        _sizeLab = [UILabel new];
        _sizeLab.font = Lantinghei(DetailFontSize);
        _sizeLab.text =  @"种子大小:";
    }
    return _sizeLab;
    
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [UILabel new];
        _dateLab.font = Lantinghei(DetailFontSize);
        _dateLab.text = @"创建时间：";

    }
    return _dateLab;
    
}

- (UILabel *)dateDetailLab {
    if (!_dateDetailLab) {
        _dateDetailLab = [UILabel new];
        _dateDetailLab.font = Lantinghei(DetailFontSize);
        _dateDetailLab.textColor = RGB(255, 136, 29);
    }
    return _dateDetailLab;
    
}

- (UIImageView *)magneticCopyImage {
    
    if (!_magneticCopyImage) {
        _magneticCopyImage= [UIImageView new];
        _magneticCopyImage.image = [UIImage imageNamed:@"copy"];
    }
    return _magneticCopyImage;
}

@end
