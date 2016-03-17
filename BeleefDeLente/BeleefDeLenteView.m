//
//  BeleefDeLenteView.m
//  BeleefDeLente
//
//  Created by Jeroen Wesbeek on 3/17/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

#import "BeleefDeLenteView.h"

@implementation BeleefDeLenteView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
