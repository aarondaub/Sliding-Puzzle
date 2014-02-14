//
// UIImage+ADCGIFSupport.m
// UIImage+Gif
//
// Created by Aaron Daub on 12/10/2013.
// Copyright (c) 2013 Aaron Daub. All rights reserved.
//

#import "UIImage+GIF.h"
@import ImageIO;

@implementation UIImage (ADCGIFSupport)

+ (instancetype)GIF_animatedImageFromGIFData:(NSData *)data{
    if(!data){
        return nil; // nice try...
    }
    
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t numberOfFrames = CGImageSourceGetCount(imageSourceRef);
    
    if(!numberOfFrames){
        return nil;
    }
    
    NSTimeInterval animationDuration = 0.0f;
    NSMutableArray* mutableFrames = [NSMutableArray array];
    
    for(size_t i = 0; i < numberOfFrames; i++){
        NSDictionary* imageProperties = (__bridge_transfer NSDictionary*)(CGImageSourceCopyPropertiesAtIndex(imageSourceRef, i, NULL));
        NSNumber* frameDurationNumber = imageProperties[(__bridge NSString*)kCGImagePropertyGIFDictionary][(__bridge NSString*)kCGImagePropertyGIFDictionary];
        
        animationDuration += (frameDurationNumber.floatValue + 1.0f/10.0f);
        
        CGImageRef frame = CGImageSourceCreateImageAtIndex(imageSourceRef, i, NULL);
        mutableFrames[i] = [UIImage imageWithCGImage:frame];
        CGImageRelease(frame);
    }
    
    
    CFRelease(imageSourceRef);
    return [self animatedImageWithImages:mutableFrames.copy duration:animationDuration];
}

@end

