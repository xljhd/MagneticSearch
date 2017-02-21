//
//  movieModel.h
//  magnetX
//
//  Created by xiaxia on 16/10/21.
//  Copyright © 2016年 728599123@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern sideModel *selectSideRule;

@interface movieModel : NSObject
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* size;
@property (nonatomic,strong)NSString* count;
@property (nonatomic,strong)NSString* source;
@property (nonatomic,strong)NSString* magnet;
@property (nonatomic,strong)NSString* cellID;

+ (movieModel*)entity:(ONOXMLElement *)element;
+ (NSArray<movieModel*>*)HTMLDocumentWithData:(NSData*)data;
@end
