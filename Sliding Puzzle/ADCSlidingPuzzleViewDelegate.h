//
//  ADCSlidingPuzzleViewDelegate.h
//  Sliding Puzzle
//
//  Created by Aaron on 2/9/2014.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADCSlidingPuzzleIncludes.h"

@class ADCSlidingPuzzleView;

@protocol ADCSlidingPuzzleViewDelegate <NSObject>

@required

- (BOOL)canEmptyTileBeMovedInDirection:(ADCSlidingPuzzleModelMoveDirection)moveDirection;
- (CGSize)puzzleSize;
- (UIView*)prepareView:(UIView*)view forTileAtCoordinate:(CGPoint)tileCoordinate;

- (void)userDidRequestMoveInDirection:(ADCSlidingPuzzleModelMoveDirection)moveDirection inSlidingPuzzleView:(ADCSlidingPuzzleView*)slidingPuzzleView;

@optional

- (void)exchangeTileRepresentedByView:(UIView*)firstTileView withTileRepresentedByView:(UIView*)secondTileView;

@end
