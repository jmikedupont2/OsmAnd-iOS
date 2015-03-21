//
//  OAPOI.h
//  OsmAnd
//
//  Created by Alexey Kulish on 18/03/15.
//  Copyright (c) 2015 OsmAnd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAPOIType : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *tag;
@property (nonatomic) NSString *value;

@property (nonatomic) NSString *nameLocalizedEN;
@property (nonatomic) NSString *nameLocalized;

@property (nonatomic) NSString *category;
@property (nonatomic) NSString *categoryLocalizedEN;
@property (nonatomic) NSString *categoryLocalized;
@property (nonatomic) NSString *filter;

- (UIImage *)icon;

@end
