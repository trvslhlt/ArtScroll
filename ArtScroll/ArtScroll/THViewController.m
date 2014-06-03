//
//  THViewController.m
//  SwipeGridGame
//
//  Created by travis holt on 5/18/14.
//  Copyright (c) 2014 travis holt. All rights reserved.
//

#import "THViewController.h"

@interface THViewController ()

@end

@implementation THViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareImageArray];
    [self prepareNextPuzzle];
}

-(void)prepareImageArray {
    self.imageInfoArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    
    self.imageArray = [[NSMutableArray alloc] init];
    UIImage *img1 = [UIImage imageNamed:@"bacon.jpg"];
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"Francis Bacon" forKey:@"artist"];
    [dict setValue:@"Painting (1946)" forKey:@"title"];
    [self.imageInfoArray addObject:dict];
    UIImage *img2 = [UIImage imageNamed:@"fountain.jpg"];
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"Marcel Duchamp" forKey:@"artist"];
    [dict setValue:@"Fountain (1917)" forKey:@"title"];
    [self.imageInfoArray addObject:dict];
    UIImage *img3 = [UIImage imageNamed:@"pollock.jpg"];
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"Jackson Pollock" forKey:@"artist"];
    [dict setValue:@"Full Fathom Five (1949)" forKey:@"title"];
    [self.imageInfoArray addObject:dict];
    UIImage *img4 = [UIImage imageNamed:@"chuck.jpg"];
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"Chuck Close" forKey:@"artist"];
    [dict setValue:@"Self Portrait (2000)" forKey:@"title"];
    [self.imageInfoArray addObject:dict];
    UIImage *img5 = [UIImage imageNamed:@"roy.jpg"];
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"Roy Lichtenstein" forKey:@"artist"];
    [dict setValue:@"Drowning Girl (1963)" forKey:@"title"];
    [self.imageInfoArray addObject:dict];
    [self.imageArray addObject:img1];
    [self.imageArray addObject:img2];
    [self.imageArray addObject:img3];
    [self.imageArray addObject:img4];
    [self.imageArray addObject:img5];
    
    self.currentImageIndex = 0;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.score++;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",self.score];
    NSString *tag = [NSString stringWithFormat:@"%ld",(long)scrollView.tag];
    NSValue *val = [self.targetOffsetDictionary objectForKey:tag];
    CGPoint targetOffset = [val CGPointValue];
//    NSLog(@"%f\n",scrollView.contentOffset.x);
//    NSLog(@"%f\n\n\n",scrollView.contentOffset.y);
    float diffX = fabsf(scrollView.contentOffset.x - targetOffset.x);
    float diffY = fabsf(scrollView.contentOffset.y - targetOffset.y);
    if ((diffX < 1.0) && (diffY < 1.0)) {
        scrollView.scrollEnabled = FALSE;
        UILabel *label = (UILabel*)[scrollView viewWithTag:(scrollView.tag*100)];
        label.alpha = 0.0f;
        self.completedCells++;
    }
    if (self.completedCells == (self.rows * self.columns)) {
        int index = (self.currentImageIndex-1) % [self.imageArray count];
        NSMutableDictionary *dict = [self.imageInfoArray objectAtIndex:index];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [dict objectForKey:@"artist"] message: [dict objectForKey:@"title"] delegate: self cancelButtonTitle:@"..." otherButtonTitles:nil]; [alert show];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self prepareNextPuzzle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextLevel:(id)sender {
    [self prepareNextPuzzle];
}

-(void)prepareNextPuzzle {
    
    self.completedCells = 0;
    self.rows = 2 + arc4random() % 5;
    self.columns = 2 + arc4random() % 3;
    
    if (self.currentImageIndex == 0) {
        self.targetOffsetDictionary = [[NSMutableDictionary alloc] init];
        self.score = 0;
        self.scoreLabel.layer.cornerRadius = 10.0f;
        
        self.rows = 7;
        self.columns = 5;
        
        int tag = 1;
        
        float cellWidth = self.gridView.frame.size.width / self.columns;
        float cellHeight = self.gridView.frame.size.height / self.rows;
        int index = self.currentImageIndex % [self.imageArray count];
        UIImage *img = [self.imageArray objectAtIndex:index];
        
        for (int i = 0; i < self.rows; i++) {
            for (int j = 0; j < self.columns; j++) {
                UIScrollView *scrollView = [[UIScrollView alloc] init];
                scrollView.frame = CGRectMake(j*cellWidth, i*cellHeight, cellWidth, cellHeight);
                scrollView.backgroundColor = [UIColor blackColor];
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.showsVerticalScrollIndicator = NO;
                CGSize contentSize = self.gridView.frame.size;
                scrollView.contentSize = contentSize;
                scrollView.pagingEnabled = YES;
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.gridView.frame.size.width, self.gridView.frame.size.height)];
                imgView.image = img;
                imgView.tag = tag *200;
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                [scrollView addSubview:imgView];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.gridView.frame.size.width, self.gridView.frame.size.height)];
                label.alpha = 0.4f;
                label.backgroundColor = [UIColor whiteColor];
                label.tag = tag *100;
                [scrollView addSubview:label];
                [self.gridView addSubview:scrollView];
                float xOffset = (float)(arc4random() % (int)(self.gridView.frame.size.width - cellWidth));
                float yOffset = (float)(arc4random() % (int)(self.gridView.frame.size.height - cellHeight));
                scrollView.contentOffset = CGPointMake(xOffset, yOffset);
                scrollView.tag = tag;
                scrollView.delegate = self;
                CGPoint targetOffset = CGPointMake(j*cellWidth, i*cellHeight);
                [self.targetOffsetDictionary setValue:[NSValue valueWithCGPoint:targetOffset] forKey:[NSString stringWithFormat:@"%d",tag]];
                tag++;
            }
        }
        self.currentImageIndex++;
    } else {
//        self.targetOffsetDictionary = [[NSMutableDictionary alloc] init];
        self.score = 0;
//        self.scoreLabel.layer.cornerRadius = 10.0f;
        
        int tag = 1;
        float cellWidth = self.gridView.frame.size.width / self.columns;
        float cellHeight = self.gridView.frame.size.height / self.rows;
        int index = self.currentImageIndex % [self.imageArray count];
        UIImage *img = [self.imageArray objectAtIndex:index];
        
        for (int i = 0; i < self.rows; i++) {
            for (int j = 0; j < self.columns; j++) {
                UIScrollView *scrollView = (UIScrollView*)[self.gridView viewWithTag:tag];
//                UIScrollView *scrollView = [[UIScrollView alloc] init];
                scrollView.frame = CGRectMake(j*cellWidth, i*cellHeight, cellWidth, cellHeight);
//                scrollView.backgroundColor = [UIColor blackColor];
//                CGSize contentSize = self.gridView.frame.size;
//                scrollView.contentSize = contentSize;
                scrollView.scrollEnabled = YES;
                UIImageView *imgView = (UIImageView*)[scrollView viewWithTag:tag*200];
                imgView.image = img;
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                [scrollView addSubview:imgView];
                UILabel *label = (UILabel*)[scrollView viewWithTag:tag*100];
                label.alpha = 0.4f;
                label.backgroundColor = [UIColor whiteColor];
                label.tag = tag *100;
                [scrollView addSubview:label];
                [self.gridView addSubview:scrollView];
                float xOffset = (float)(arc4random() % (int)(self.gridView.frame.size.width - cellWidth));
                float yOffset = (float)(arc4random() % (int)(self.gridView.frame.size.height - cellHeight));
                scrollView.contentOffset = CGPointMake(xOffset, yOffset);
                scrollView.tag = tag;
                scrollView.delegate = self;
                CGPoint targetOffset = CGPointMake(j*cellWidth, i*cellHeight);
                [self.targetOffsetDictionary setValue:[NSValue valueWithCGPoint:targetOffset] forKey:[NSString stringWithFormat:@"%d",tag]];
                tag++;
                self.score = 0;
                self.scoreLabel.text = @"0";
            }
        }
        self.currentImageIndex++;
    }
    
}


@end




