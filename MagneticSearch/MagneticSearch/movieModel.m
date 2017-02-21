//
//  movieModel.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/21.
//  Copyright © 2016年 728599123@qq.com. All rights reserved.
//

#import "movieModel.h"
sideModel *selectSideRule;

@implementation movieModel
-(void)setName:(NSString *)name{
    if (name) {
        _name = [name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }else{
        _name = @"";
    }
}
-(void)setMagnet:(NSString *)magnet{
    if (magnet) {
        _magnet = magnet;
    }else{
        _magnet = @"";
    }
}
-(void)setSize:(NSString *)size{
    if (size) {
        _size = size;
    }else{
        _size = @"";
    }
}
-(void)setCount:(NSString *)count{
    if (count) {
        _count = count;
    }else{
        _count = @"";
    }
}
- (void)setSource:(NSString *)source{
    if (source) {
        _source = source;
    }else{
        _source = @"";
    }
}
+ (movieModel*)entity:(ONOXMLElement *)element{
    movieModel*Model = [movieModel new];
    NSString*firstMagnet = [element firstChildWithXPath:selectSideRule.magnet].stringValue;
    if ([firstMagnet hasSuffix:@".html"]) {
        firstMagnet = [firstMagnet stringByReplacingOccurrencesOfString:@".html"withString:@""];
    }
    if ([firstMagnet componentsSeparatedByString:@"&"].count>1) {
        firstMagnet = [firstMagnet componentsSeparatedByString:@"&"][0];
    }
    NSString*magnet=[firstMagnet substringWithRange:NSMakeRange(firstMagnet.length-40,40)];
    Model.magnet = [NSString stringWithFormat:@"magnet:?xt=urn:btih:%@",magnet];
    Model.name = [[element firstChildWithXPath:selectSideRule.name] stringValue];
    Model.size = [[element firstChildWithXPath:selectSideRule.size] stringValue];
    Model.count = [[element firstChildWithXPath:selectSideRule.count] stringValue];
    Model.cellID = @"MagnetsCellTableViewCell";
//    Model.source =selectSideRule.site;
    return Model;
}

+ (NSArray*)HTMLDocumentWithData:(NSData*)data{
    NSMutableArray*array = [NSMutableArray new];
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:nil];
    [doc enumerateElementsWithXPath:selectSideRule.group usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        movieModel*movie = [movieModel entity:element];
//        movie.source = url;
        [array addObject:movie];
    }];
    return array;
}

@end
