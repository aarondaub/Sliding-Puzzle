//
//  ADCSlidingPuzzleView.h
//  Sliding Puzzle
//
//  Created by Aaron on 2/9/2014.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADCSlidingPuzzleViewDelegate.h"

@interface ADCSlidingPuzzleView : UIView

@property (nonatomic, weak, readwrite) id<ADCSlidingPuzzleViewDelegate>delegate;

- (void)exchangeTileRepresentedByView:(UIView*)firstTileView withTileRepresentedByView:(UIView*)secondTileView;

- (UIView*)tileViewAtIndex:(NSUInteger)index;
- (UIView*)emptyTileView;


@end
