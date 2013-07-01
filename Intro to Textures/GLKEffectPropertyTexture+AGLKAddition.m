//
//  GLKEffectPropertyTexture+AGLKAddition.m
//  Intro to Textures
//
//  Created by Hamdan Javeed on 2013-07-01.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "GLKEffectPropertyTexture+AGLKAddition.h"

@implementation GLKEffectPropertyTexture (AGLKAddition)

- (void)aglkSetParameter:(GLenum)parameterID
               withValue:(GLint)value {
    glBindTexture(self.target, self.name);
    
    glTexParameteri(self.target, parameterID, value);
}

@end
