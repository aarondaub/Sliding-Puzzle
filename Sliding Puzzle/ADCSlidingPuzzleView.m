//
//  ADCSlidingPuzzleView.m
//  Sliding Puzzle
//
//  Created by Aaron on 2/9/2014.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import "ADCSlidingPuzzleView.h"
#import "ADCSlidingPuzzleIncludes.h"

@interface ADCSlidingPuzzleView ()

@property (nonatomic, readwrite, assign) NSUInteger tagOfEmptyTile;
@end

@implementation ADCSlidingPuzzleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithIndexOfEmptyTile:(NSUInteger)indexOfEmptyTile frame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.tagOfEmptyTile = indexOfEmptyTile;
    }
    
    return self;
    
}

- (void)exchangeTileRepresentedByView:(UIView *)firstTileView withTileRepresentedByView:(UIView*)secondTileView{
    if([self.delegate respondsToSelector:@selector(exchangeTileRepresentedByView:withTileRepresentedByView:)]){
        [self updateTagsOfViewInExchangeOf:firstTileView with:secondTileView];
        [self.delegate exchangeTileRepresentedByView:firstTileView withTileRepresentedByView:secondTileView];
    }else{
        CGPoint initialFirstTileViewCenter = firstTileView.center;
        CGPoint initialSecondTileViewCenter = secondTileView.center;
           [self updateTagsOfViewInExchangeOf:firstTileView with:secondTileView];
        [UIView animateWithDuration:0.25f animations:^{
            firstTileView.center = initialSecondTileViewCenter;
            secondTileView.center = initialFirstTileViewCenter;
        } completion:^(BOOL finished) {
      //      NSLog(@"Views: @[%@, %@] were exchanged successfully", firstTileView, secondTileView);
         
        }];
    }
    
}

- (void)layoutSubviews{
    CGSize size = [self.delegate puzzleSize];
    if(!CGSizeEqualToSize(size, CGSizeZero)){
        CGFloat tileWidth = (NSUInteger)self.frame.size.width / size.width;
        CGFloat tileHeight = (NSUInteger)self.frame.size.height / size.height;
        NSUInteger i = 0;
        for(NSUInteger y = 0; y < (NSUInteger)size.height; y++){
            for(NSUInteger x = 0; x < (NSUInteger)size.width; x++){
                UIView* tileView = [[UIView alloc] init];
                CGRect tileViewFrame = CGRectMake(tileWidth * x, tileHeight * y, tileWidth, tileHeight);
                tileView.frame = tileViewFrame;
                [self.delegate prepareView:tileView forTileAtCoordinate:CGPointMake(x, y)];
                tileView.tag = i++;
                [self addSubview:tileView];
            }
        }
        
    }
}


- (UIView*)tileViewAtIndex:(NSUInteger)index{
    __block UIView* tileView;
    [self.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        if(view.tag == index){
            tileView = view;
            *stop = YES;
        }
    }];
    if(!tileView){
        NSLog(@"");
    }
    return tileView;
}

- (UIView*)emptyTileView{
    return [self tileViewAtIndex:self.tagOfEmptyTile];
}

#pragma mark - Private Interface

- (CGPoint)coordinateOfTileView:(UIView*)tileView{
    return  CGPointMake(tileView.tag % (NSUInteger)[self.delegate puzzleSize].width, tileView.tag / (NSUInteger)[self.delegate puzzleSize].width);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(touches.allObjects.count == 1){
        CGPoint locationInView = [touches.anyObject locationInView:self];
        UIView* struckView = [self hitTest:locationInView withEvent:event];
        UIView* emptyView = [self emptyTileView];
        CGPoint coordinateOfStruckView = [self coordinateOfTileView:struckView];
        CGPoint coordinateOfEmptyView = [self coordinateOfTileView:emptyView];
        ADCSlidingPuzzleModelMoveDirection moveDirection = moveDirectionBetweenCoordinates(coordinateOfEmptyView, coordinateOfStruckView);
        [self.delegate userDidRequestMoveInDirection:moveDirection inSlidingPuzzleView:self];
      //  [self.delegate userDidTapTileAtCoordinate:coordinateOfStruckView inSlidingPuzzleView:self];
    }
}

- (void)updateTagsOfViewInExchangeOf:(UIView*)firstTileView with:(UIView*)secondTileView{
    if(firstTileView.tag == self.tagOfEmptyTile){
        self.tagOfEmptyTile = secondTileView.tag;
    }else if (secondTileView.tag == self.tagOfEmptyTile){
        self.tagOfEmptyTile = firstTileView.tag;
    }
    
    NSInteger temporaryTag = firstTileView.tag;
    firstTileView.tag = secondTileView.tag;
    secondTileView.tag = temporaryTag;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
