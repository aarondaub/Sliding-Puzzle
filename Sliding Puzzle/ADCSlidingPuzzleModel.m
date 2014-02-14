//
//  ADCSlidingPuzzleModel.m
//  Sliding Puzzle
//
//  Created by Aaron on 2/5/2014.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import "ADCSlidingPuzzleModel.h"

#define SWAP(type,x, y) \
{ \
type temp = x; \
x = y;\
y = temp;\
}

@interface ADCSlidingPuzzleTileModel : NSObject

@property (nonatomic, readonly, getter = isEmpty) BOOL empty;
@property (nonatomic, readonly) NSUInteger ID;

- (instancetype)initWithID:(NSUInteger)ID;

@end

@interface ADCSlidingPuzzleTileModel ()

@property (nonatomic, readwrite, assign) BOOL empty;
@property (nonatomic, readwrite, assign) NSUInteger ID;

@end

@implementation ADCSlidingPuzzleTileModel

- (instancetype)initWithID:(NSUInteger)ID{
    if(self = [super init]){
        self.ID = ID;
        self.empty = !(BOOL)(ID);
    }
    return self;
}

@end

@interface ADCSlidingPuzzleModel ()

@property (nonatomic, readwrite, assign) CGSize size;
@property (nonatomic, readwrite, strong) NSMutableArray* tiles;

@end

@implementation ADCSlidingPuzzleModel

- (instancetype)init{
    if(self = [super init]){
        self.size = CGSizeZero;
    }
    return self;
}

+ (instancetype)slidingPuzzleMoelWithWidth:(NSUInteger)width height:(NSUInteger)height{
    return [self slidingPuzzleMoelWithWidth:width height:height startingTilePositions:nil];
}

+ (instancetype)slidingPuzzleMoelWithWidth:(NSUInteger)width height:(NSUInteger)height startingTilePositions:(NSArray*)tilePositions{
    ADCSlidingPuzzleModel* slidingPuzzleModel = [[self alloc] init];
    slidingPuzzleModel.size = CGSizeMake(width, height);
    slidingPuzzleModel.tiles = tilePositions.mutableCopy;
    return slidingPuzzleModel;
}


- (NSMutableArray*)tiles{
    if(_tiles){
        return _tiles;
    }
    
    if(CGSizeEqualToSize(self.size, CGSizeZero)){
        return nil;
    }
    
    _tiles = [NSMutableArray array];
    for(NSUInteger i = 0; i < self.size.width * self.size.height; i++){
        [_tiles addObject:[[ADCSlidingPuzzleTileModel alloc] initWithID:i]];
    }
    return _tiles;
}

- (void)shuffleWithIndexesOfTiles:(NSArray *)indexesOfTiles{
    [indexesOfTiles enumerateObjectsUsingBlock:^(NSNumber* indexNumber, NSUInteger idx, BOOL *stop) {
        CGPoint coordinateOfTileToSwap = [self coordinateOfTileAtIndex:indexNumber.unsignedIntegerValue];
        [self exchangeEmptyTileWithTileAtCoordinate:coordinateOfTileToSwap];
    }];
}

- (NSArray*)indexesOfTilesToPerformAShuffle{
       NSUInteger shuffleCount =  pow(self.size.height, 1.5f);
    ADCSlidingPuzzleModel* proxyPuzzle = [[self class] slidingPuzzleMoelWithWidth:self.size.width height:self.size.height startingTilePositions:self.tiles.copy];
    return [proxyPuzzle generateIndexesOfTilesToMoveRepeatedly:shuffleCount];
}

- (BOOL)canMoveEmptyTileInDirection:(ADCSlidingPuzzleModelMoveDirection)moveDirection{
    CGPoint destinationTileCoordinate = [self tileAdjacentToEmptyTileInDirection:moveDirection];
    return (destinationTileCoordinate.x >= 0 && destinationTileCoordinate.x < self.size.width && destinationTileCoordinate.y >= 0 && destinationTileCoordinate.y < self.size.height);
}

- (void)moveEmptyTileInDirectionIfPossible:(ADCSlidingPuzzleModelMoveDirection)moveDirection{
    if([self canMoveEmptyTileInDirection:moveDirection]){
        CGPoint destinationTileCoordinate = [self tileAdjacentToEmptyTileInDirection:moveDirection];
        [self exchangeEmptyTileWithTileAtCoordinate:destinationTileCoordinate];
    }
}

- (NSUInteger)indexOfTileInMoveDirection:(ADCSlidingPuzzleModelMoveDirection)moveDirection{
    if([self canMoveEmptyTileInDirection:moveDirection]){
        return [self indexOfTileAtCoordinate:[self tileAdjacentToEmptyTileInDirection:moveDirection]];
    }
    return 0;
}

- (BOOL)isTileAtCoordinateEmpty:(CGPoint)tileCoordinate{
    return ([self indexOfTileAtCoordinate:tileCoordinate] == [self indexOfEmptyTile]);
}


- (NSString*)debugDescription{
    NSMutableString* debugString = [NSMutableString stringWithString:@""];
    [self.tiles enumerateObjectsUsingBlock:^(ADCSlidingPuzzleTileModel* tile, NSUInteger idx, BOOL *stop) {
        if(idx % (NSUInteger)self.size.width != 0){
            [debugString appendString:@" "];
        }
        [debugString appendString:[NSString stringWithFormat:@"%d", tile.ID]];
        if(idx % (NSUInteger)self.size.width + 1 == self.size.width){
            [debugString appendString:@"\n"];
        }else{
            [debugString appendString:@","];
        }
    }];
    return debugString.copy;
}

- (void)setSize:(CGSize)size{
    if(!CGSizeEqualToSize(_size, size) && size.width > 1 && size.height > 1){
        _size = size;
    }
}

#pragma mark - Private Interface

- (CGPoint)tileAdjacentToEmptyTileInDirection:(ADCSlidingPuzzleModelMoveDirection)moveDirection{
    CGPoint emptyTileCoordinate = [self coordinateOfTileAtIndex:[self indexOfEmptyTile]];
    CGPoint destinationTileCoordinate = emptyTileCoordinate;
    switch (moveDirection) {
        case ADCSlidingPuzzleModelMoveDirectionLeft:
            destinationTileCoordinate.x--;
            break;
        case ADCSlidingPuzzleModelMoveDirectionRight:
            destinationTileCoordinate.x++;
            break;
        case ADCSlidingPuzzleModelMoveDirectionUp:
            destinationTileCoordinate.y++;
            break;
        case ADCSlidingPuzzleModelMoveDirectionDown:
            destinationTileCoordinate.y--;
            break;
        default:
            break;
    }
    return destinationTileCoordinate;
}

- (NSUInteger)indexOfEmptyTile{
    __block  NSUInteger indexOfEmptyBlock = 0;
    [self.tiles enumerateObjectsUsingBlock:^(ADCSlidingPuzzleTileModel* tile, NSUInteger idx, BOOL *stop) {
        if(tile.isEmpty){
            indexOfEmptyBlock = idx;
            *stop = YES;
        }
    }];
    return indexOfEmptyBlock;
}

- (CGPoint)randomAdjacentTileToEmptyTile{
    ADCSlidingPuzzleModelMoveDirection direction = arc4random_uniform(4);
    if([self canMoveEmptyTileInDirection:direction]){
        CGPoint adjacentTileCoordinate = [self tileAdjacentToEmptyTileInDirection:direction];
        return adjacentTileCoordinate;
    }
    return [self randomAdjacentTileToEmptyTile];
}

- (CGPoint)coordinateOfTileAtIndex:(NSUInteger)index{
    return CGPointMake(index % (NSUInteger)self.size.width, index / (NSUInteger)self.size.width);
}

- (NSUInteger)indexOfTileAtCoordinate:(CGPoint)coordinate{
    return (NSUInteger)self.size.width * coordinate.y + coordinate.x;
}

- (void)exchangeEmptyTileWithTileAtCoordinate:(CGPoint)coordinateOfFutureEmptyTile{
    NSUInteger indexOfEmptyBlock = [self indexOfEmptyTile];
    
    NSUInteger indexOfBlockToSwitch = [self indexOfTileAtCoordinate:coordinateOfFutureEmptyTile];
    
    SWAP(id, self.tiles[indexOfEmptyBlock], self.tiles[indexOfBlockToSwitch]);
    
    if([self isPuzzleSolved] && self.solvedBlock){
        self.solvedBlock(self);
    }
}

- (BOOL)isPuzzleSolved{
    __block BOOL solved = YES;
    [self.tiles enumerateObjectsUsingBlock:^(ADCSlidingPuzzleTileModel* tile, NSUInteger idx, BOOL *stop) {
        if(tile.ID != idx){
            solved = NO;
            *stop = YES;
        }
    }];
    return solved;
}

- (void)shuffleRepeatedly:(NSUInteger)numberOfTimesToShuffle{
    CGPoint coordinateOfBlockToSwitch = [self randomAdjacentTileToEmptyTile];
    
    [self exchangeEmptyTileWithTileAtCoordinate:coordinateOfBlockToSwitch];
    
    if(numberOfTimesToShuffle){
        [self shuffleRepeatedly:numberOfTimesToShuffle - 1];
    }
}

ADCSlidingPuzzleModelMoveDirection moveDirectionBetweenCoordinates(CGPoint to, CGPoint from){
    CGFloat xDelta = abs(to.x - from.x);
    CGFloat yDelta = abs(to.y - from.y);
    if(xDelta > yDelta){
        if(to.x > from.x){
            return ADCSlidingPuzzleModelMoveDirectionLeft;
        }else {
            return ADCSlidingPuzzleModelMoveDirectionRight;
        }
    }else if (to.y < from.y){
        return ADCSlidingPuzzleModelMoveDirectionUp;
    }
    return ADCSlidingPuzzleModelMoveDirectionDown;
}

- (NSArray*)generateMoveDirectionRepeatedly:(NSUInteger)numberOfMoves{
    CGPoint emptyBlockCoordinate = [self coordinateOfTileAtIndex:[self indexOfEmptyTile]];
    CGPoint coordinateOfBlockToSwitch = [self randomAdjacentTileToEmptyTile];
    NSMutableArray* moves = [NSMutableArray array];
    [moves addObject:@(moveDirectionBetweenCoordinates(emptyBlockCoordinate, coordinateOfBlockToSwitch))];
    if(numberOfMoves){
        [moves addObjectsFromArray:[self generateMoveDirectionRepeatedly:numberOfMoves - 1]];
    }
    return moves.copy;

}

- (NSArray*)generateIndexesOfTilesToMoveRepeatedly:(NSUInteger)numberOfMoves{
    CGPoint coordinateOfBlockToSwitch = [self randomAdjacentTileToEmptyTile];
    NSMutableArray* moves = [NSMutableArray array];
    NSUInteger indexOfTileToSwap = [self indexOfTileAtCoordinate:coordinateOfBlockToSwitch];
    [moves addObject:@(indexOfTileToSwap)];
    [self exchangeEmptyTileWithTileAtCoordinate:coordinateOfBlockToSwitch];
    if(numberOfMoves){
        [moves addObjectsFromArray:[self generateIndexesOfTilesToMoveRepeatedly:numberOfMoves - 1]];
    }
    return moves.copy;
}

- (void)performMove:(ADCSlidingPuzzleModelMoveDirection)direction{
    CGPoint toTile = [self tileAdjacentToEmptyTileInDirection:direction];
    [self exchangeEmptyTileWithTileAtCoordinate:toTile];
}

@end


