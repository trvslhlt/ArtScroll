//
//  THLevel.h
//  SwipeGridGame
//
//  Created by travis holt on 5/18/14.
//  Copyright (c) 2014 travis holt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THCell.h"

@interface THLevel : NSObject

@property (nonatomic) NSInteger rows;
@property (nonatomic) NSInteger columns;

@property (nonatomic, retain) UIImage *img;

@end
