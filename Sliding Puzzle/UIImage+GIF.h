//
// UIImage+ADCGIFSupport.h
// UIImage+Gif
//
// Created by Aaron Daub on 12/10/2013.
// Copyright (c) 2013 Aaron Daub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ADCGIFSupport)

+ (instancetype)GIF_animatedImageFromGIFData:(NSData*)data;

@end