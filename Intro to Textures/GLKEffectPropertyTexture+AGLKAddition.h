//
//  GLKEffectPropertyTexture+AGLKAddition.h
//  Intro to Textures
//
//  Created by Hamdan Javeed on 2013-07-01.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface GLKEffectPropertyTexture (AGLKAddition)

- (void)aglkSetParameter:(GLenum)parameterID
               withValue:(GLint)value;

@end
