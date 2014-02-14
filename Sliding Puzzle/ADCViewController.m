//
//  ADCViewController.m
//  Sliding Puzzle
//
//  Created by Aaron on 2/9/2014.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import "ADCViewController.h"
#import "ADCSlidingPuzzleModel.h"
#import "ADCSlidingPuzzleView.h"
#import "UIImage+GIF.h"

@import AVFoundation;

@interface ADCViewController () <ADCSlidingPuzzleViewDelegate>

@property (nonatomic, readwrite, strong) ADCSlidingPuzzleModel* puzzleModel;
@property (nonatomic, readwrite, strong) ADCSlidingPuzzleView* puzzleView;
@property (nonatomic, readwrite, strong) AVPlayer* videoPlayer;
@property (nonatomic, readwrite, strong) NSData* GIFData;

@end

@implementation ADCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.puzzleView.frame = self.view.bounds;
    [self.view insertSubview:self.puzzleView atIndex:0];
    
}

- (NSData*)GIFData{
    if(_GIFData){
        return _GIFData;
    }
    
    _GIFData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"optical2" withExtension:@"gif"]];
    return _GIFData;
}

- (IBAction)shuffle:(UIButton *)sender {
    NSArray* indexesOfTilesToSwap = [self.puzzleModel indexesOfTilesToPerformAShuffle];
    
    [indexesOfTilesToSwap enumerateObjectsUsingBlock:^(NSNumber* indexNumber, NSUInteger idx, BOOL *stop) {
        [self.puzzleView exchangeTileRepresentedByView:[self.puzzleView emptyTileView] withTileRepresentedByView:[self.puzzleView tileViewAtIndex:indexNumber.unsignedIntegerValue]];
    }];
    
    [self.puzzleModel shuffleWithIndexesOfTiles:indexesOfTilesToSwap];
    
    [self.videoPlayer play];
}

#pragma mark - Properties

- (ADCSlidingPuzzleModel*)puzzleModel{
    if(_puzzleModel){
        return _puzzleModel;
    }
    
    _puzzleModel = [ADCSlidingPuzzleModel slidingPuzzleMoelWithWidth:self.puzzleSize.width height:self.puzzleSize.height];
    
    _puzzleModel.solvedBlock = ^(ADCSlidingPuzzleModel* puzzle){
        NSLog(@"Woo");
    };
    
    return _puzzleModel;
}

- (ADCSlidingPuzzleView*)puzzleView{
    if(_puzzleView){
       return _puzzleView;
    }
    
    _puzzleView = [[ADCSlidingPuzzleView alloc] init];
    _puzzleView.delegate = self;

    return _puzzleView;
}

- (AVPlayer*)videoPlayer{
    if(_videoPlayer){
        return _videoPlayer;
    }
    
  // _videoPlayer = [[AVPlayer alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"vid" withExtension:@"mov"]];
    
    return _videoPlayer;
}

#pragma mark - ADCSlidingPuzzleViewDelgate

- (BOOL)canEmptyTileBeMovedInDirection:(ADCSlidingPuzzleModelMoveDirection)moveDirection{
    return [self.puzzleModel canMoveEmptyTileInDirection:moveDirection];
}

- (CGSize)puzzleSize{
    return CGSizeMake(4, 7);
}

static UIImage* GIFImage;

- (UIView*)prepareView:(UIView*)view forTileAtCoordinate:(CGPoint)tileCoordinate{
    
    if(![self.puzzleModel isTileAtCoordinateEmpty:tileCoordinate]){
        CGFloat xFraction = tileCoordinate.x  / self.puzzleSize.width;
        CGFloat yFraction = tileCoordinate.y  / self.puzzleSize.height;
  //  /* //   UIImage* catImage = [UIImage imageNamed:@"cat.jpg"];
  
        if(!GIFImage){
            GIFImage = [UIImage GIF_animatedImageFromGIFData:self.GIFData];
        }
        
        UIImageView* catImageView = [[UIImageView alloc] initWithImage:GIFImage];
        [catImageView startAnimating];
        catImageView.frame = self.puzzleView.bounds;
        catImageView.layer.contentsRect = CGRectMake(xFraction,yFraction, 1.0f, 1.0f);
        [view addSubview:catImageView];
        view.clipsToBounds = YES;//*/
        
        /* VIDEO
      //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
           
            
            

            // CGRect cRect = CGRectMake(xFraction , yFraction, 1.0f, 1.0f);
            // playerLayer.contentsRect = cRect;
          //  dispatch_sync(dispatch_get_main_queue(), ^{
                 playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                playerLayer.frame = CGRectMake(-xFraction * self.puzzleView.bounds.size.width, -yFraction * self.puzzleView.bounds.size.height, self.puzzleView.bounds.size.width, self.puzzleView.bounds.size.height);
                [view.layer addSublayer:playerLayer];
                view.clipsToBounds = YES;
        //    });
         
       // });
      
        // */
    }else{
        view.backgroundColor = [UIColor yellowColor];
    }
    
    return view;
}

- (void)userDidRequestMoveInDirection:(ADCSlidingPuzzleModelMoveDirection)moveDirection inSlidingPuzzleView:(ADCSlidingPuzzleView *)slidingPuzzleView{
    BOOL moveIsPossible = [self.puzzleModel canMoveEmptyTileInDirection:moveDirection];
    if(moveIsPossible){
        NSUInteger indexOfTileToMove = [self.puzzleModel indexOfTileInMoveDirection:moveDirection];
        [self.puzzleView exchangeTileRepresentedByView:[self.puzzleView emptyTileView] withTileRepresentedByView:[self.puzzleView tileViewAtIndex:indexOfTileToMove]];
        [self.puzzleModel moveEmptyTileInDirectionIfPossible:moveDirection];
    }
}

@end
