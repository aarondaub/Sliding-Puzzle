//
//  ADCSlidingPuzzleIncludes.h
//  Sliding Puzzle
//
//  Created by Aaron on 2/9/2014.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#ifndef Sliding_Puzzle_ADCSlidingPuzzleIncludes_h
#define Sliding_Puzzle_ADCSlidingPuzzleIncludes_h

typedef NS_ENUM(NSUInteger, ADCSlidingPuzzleModelMoveDirection){
    ADCSlidingPuzzleModelMoveDirectionLeft = 0,
    ADCSlidingPuzzleModelMoveDirectionRight = 1,
    ADCSlidingPuzzleModelMoveDirectionUp = 2,
    ADCSlidingPuzzleModelMoveDirectionDown = 3
};

ADCSlidingPuzzleModelMoveDirection moveDirectionBetweenCoordinates(CGPoint to, CGPoint from);


#endif
