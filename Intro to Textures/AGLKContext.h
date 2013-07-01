//
//  AGLKContext.h
//  Base GL Project
//
//  Created by Hamdan Javeed on 2013-06-30.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

@interface AGLKContext : EAGLContext
// the color used when clearing the render buffers
@property (nonatomic) GLKVector4 clearColor;

// a method that clears the given mask from the render buffers
- (void)clear:(GLbitfield)mask;
@end
