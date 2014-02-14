//
//  ADCSlidingPuzzleModel.h
//  Sliding Puzzle
//
//  Created by Aaron on 2/5/2014.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADCSlidingPuzzleIncludes.h"

@class ADCSlidingPuzzleModel;
typedef void(^ADCSlidingPuzzelModelSolved)(ADCSlidingPuzzleModel* puzzleModel);

@interface ADCSlidingPuzzleModel : NSObject

@property (nonatomic, readwrite, strong) ADCSlidingPuzzelModelSolved solvedBlock;
@property (nonatomic, readonly) NSMutableArray* tiles;
@property (nonatomic, readonly, assign) CGSize size;

+ (instancetype)slidingPuzzleMoelWithWidth:(NSUInteger)width height:(NSUInteger)height;

- (void)shuffleWithIndexesOfTiles:(NSArray*)indexesOfTiles;

- (NSArray*)indexesOfTilesToPerformAShuffle;

- (BOOL)canMoveEmptyTileInDirection:(ADCSlidingPuzzleModelMoveDirection)moveDirection;
- (void)moveEmptyTileInDirectionIfPossible:(ADCSlidingPuzzleModelMoveDirection)moveDirection;
- (NSUInteger)indexOfTileInMoveDirection:(ADCSlidingPuzzleModelMoveDirection)moveDirection;
- (BOOL)isTileAtCoordinateEmpty:(CGPoint)tileCoordinate;

- (NSString*)debugDescription;

@end
