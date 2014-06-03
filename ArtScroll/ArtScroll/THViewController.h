//
//  THViewController.h
//  SwipeGridGame
//
//  Created by travis holt on 5/18/14.
//  Copyright (c) 2014 travis holt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLevel.h"

@interface THViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic) int rows;
@property (nonatomic) int columns;
@property (nonatomic) int currentImageIndex;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) NSMutableArray *imageInfoArray;
@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) NSMutableDictionary *targetOffsetDictionary;
@property (nonatomic) int score;
@property (nonatomic) int completedCells;

- (IBAction)nextLevel:(id)sender;

-(void) prepareImageArray;
-(void) prepareNextPuzzle;

@end
