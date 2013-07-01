//
//  AGLKVertexBufferObject.m
//  Base GL Project
//
//  Created by Hamdan Javeed on 2013-06-30.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "AGLKVertexBufferObject.h"

@interface AGLKVertexBufferObject()

@end

@implementation AGLKVertexBufferObject

- (GLuint)name {
    return name;
}

// designated initializer
- (id)initWithStride:(GLsizeiptr)initStride
    numberOfVertices:(GLsizei)vertexCount
                data:(const GLvoid *)data
            andUsage:(GLenum)usage {
    
    // check the parameters
    NSParameterAssert(initStride > 0);
    NSParameterAssert(vertexCount > 0);
    NSParameterAssert(data != nil);
    
    self = [super init];
    
    if (self) {
        stride = initStride;
        // size = (how large one vertex is) * (number of vertices)
        bufferSizeInBytes = stride * vertexCount;
        
        glGenBuffers(1, &name);
        glBindBuffer(GL_ARRAY_BUFFER, name);
        glBufferData(GL_ARRAY_BUFFER, bufferSizeInBytes, data, usage);
        
        NSAssert(name != 0, @"Could not generate name for vertex buffer.");
    }
        
    return self;
}

- (void)prepareToDrawWithAttribute:(GLuint)attribute
               numberOfCoordinates:(GLint)numberOfCoordinates
                offsetOfFirstIndex:(GLsizeiptr)offset
    andShouldEnableVertexAttribute:(BOOL)enable {
    
    // check parameters
    NSParameterAssert((numberOfCoordinates > 0) && (numberOfCoordinates < 4));
    NSParameterAssert(stride > offset);
    NSAssert(name != 0, @"Invalid name");
    
    glBindBuffer(GL_ARRAY_BUFFER, name);
    if (enable) {
        glEnableVertexAttribArray(attribute);
    }
    
    glVertexAttribPointer(attribute, numberOfCoordinates, GL_FLOAT, GL_FALSE, stride, NULL + offset);
}

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)firstIndex
      andNumberOfVertices:(GLsizei)numberOfVertices {
    
    // size >= (number of vertices) * size of each vertex
    NSAssert(bufferSizeInBytes >= ((firstIndex + numberOfVertices) * stride), @"Attempted to draw more vertex data than was available");
    
    glDrawArrays(mode, firstIndex, numberOfVertices);
}

- (void)dealloc {
    if (name != 0) {
        glDeleteBuffers(1, &name);
        name = 0;
    }
}

@end
