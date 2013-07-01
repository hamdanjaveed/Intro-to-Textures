//
//  AGLKContext.m
//  Base GL Project
//
//  Created by Hamdan Javeed on 2013-06-30.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext

- (void)setClearColor:(GLKVector4)clearColor {
    _clearColor = clearColor;
    
    NSAssert(self == [[self class] currentContext], @"Recieving context for setClearColor: is not the current context.");
    
    glClearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearColor.a);
}

- (void)clear:(GLbitfield)mask {
    NSAssert(self == [[self class] currentContext], @"Recieving context for clear: is not the current context.");
    glClear(mask);
}

@end
