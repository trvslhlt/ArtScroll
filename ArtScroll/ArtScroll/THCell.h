//
//  THCell.h
//  SwipeGridGame
//
//  Created by travis holt on 5/18/14.
//  Copyright (c) 2014 travis holt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THCell : NSObject

@property (nonatomic) CGPoint *initialContentOffset;
@property (nonatomic) CGPoint *targetContentOffset;
@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger column;

@end
