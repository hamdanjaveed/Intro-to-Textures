//
//  AGLKVertexBufferObject.h
//  Base GL Project
//
//  Created by Hamdan Javeed on 2013-06-30.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGLKVertexBufferObject : NSObject {
    GLsizeiptr stride;
    GLsizeiptr bufferSizeInBytes;
    GLuint name;
}

- (id)initWithStride:(GLsizeiptr)stride
    numberOfVertices:(GLsizei)vertexCount
                data:(const GLvoid *)data
            andUsage:(GLenum)usage;

- (void)prepareToDrawWithAttribute:(GLuint)attribute
               numberOfCoordinates:(GLint)numberOfCoordinates
                offsetOfFirstIndex:(GLsizeiptr)offset
    andShouldEnableVertexAttribute:(BOOL)enable;

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)firstIndex
      andNumberOfVertices:(GLsizei)numberOfVertices;

@end
