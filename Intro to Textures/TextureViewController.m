//
//  TextureViewController.m
//  Intro to Textures
//
//  Created by Hamdan Javeed on 2013-06-30.
//  Copyright (c) 2013 Hamdan Javeed. All rights reserved.
//

#import "TextureViewController.h"
#import "AGLKVertexBufferObject.h"
#import "AGLKContext.h"
#import "GLKEffectPropertyTexture+AGLKAddition.h"

@interface TextureViewController()
@property (strong, nonatomic) AGLKVertexBufferObject *triangleVBO;

@property (nonatomic) BOOL shouldUseLinearFilter;
@property (nonatomic) BOOL shouldAnimate;
@property (nonatomic) BOOL shouldRepeatTexture;
@property (nonatomic) GLfloat sCoordinateOffset;

- (IBAction)updatedSCoordinateOffset:(UISlider *)sender;
- (IBAction)updatedAnimateState:(UISwitch *)sender;
- (IBAction)updatedLinearFilterState:(UISwitch *)sender;
- (IBAction)updatedRepeatFilterState:(UISwitch *)sender;
@end

@implementation TextureViewController

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
} SceneVertex;

static SceneVertex vertices[] = {
    // lower left corner
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    // lower right corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    // upper left corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}
};

static const SceneVertex defaultVertices[] = {
    // lower left corner
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    // lower right corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    // upper left corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}
};

static GLKVector3 movementVectors[3] = {
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};

- (AGLKVertexBufferObject *)triangleVBO {
    if (!_triangleVBO) {
        _triangleVBO = [[AGLKVertexBufferObject alloc] initWithStride:sizeof(SceneVertex)
                                                     numberOfVertices:sizeof(vertices) / sizeof(vertices[0])
                                                                 data:vertices
                                                             andUsage:GL_DYNAMIC_DRAW];
    }
    return _triangleVBO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPreferredFramesPerSecond:60];
    [self setShouldAnimate:YES];
    [self setShouldRepeatTexture:YES];
    
    // get our view and make sure it's a GLKView
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"GLViewController's view is not a GLKView");
    
    // create a 2.0 context
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // set the current context
    [AGLKContext setCurrentContext:view.context];
    
    // create a GLKBaseEffect and set its properties
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    // make the effect use a white color to render something
    [self.baseEffect setUseConstantColor:GL_TRUE];
    [self.baseEffect setConstantColor:GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f)];
    
    // set the background color
    [((AGLKContext *)view.context) setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f)];
    
    // setup the wood texture
    GLKTextureInfo *woodTexInfo = [GLKTextureLoader textureWithCGImage:[[UIImage imageNamed:@"wood.png"] CGImage]
                                                               options:nil
                                                                 error:nil];
    
    [self.baseEffect.texture2d0 setName:woodTexInfo.name];
    [self.baseEffect.texture2d0 setTarget:woodTexInfo.target];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // tell the GLKBaseEffect to prepare itself for drawing
    [self.baseEffect prepareToDraw];
    
    // clear the frame buffer
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT];
    
    [self.triangleVBO prepareToDrawWithAttribute:GLKVertexAttribPosition
                             numberOfCoordinates:sizeof(vertices) / sizeof(vertices[0])
                              offsetOfFirstIndex:offsetof(SceneVertex, positionCoords)
                  andShouldEnableVertexAttribute:YES];
    [self.triangleVBO prepareToDrawWithAttribute:GLKVertexAttribTexCoord0
                             numberOfCoordinates:2
                              offsetOfFirstIndex:offsetof(SceneVertex, textureCoords)
                  andShouldEnableVertexAttribute:YES];
    
    [self.triangleVBO drawArrayWithMode:GL_TRIANGLES
                       startVertexIndex:0
                    andNumberOfVertices:sizeof(vertices) / sizeof(vertices[0])];
}

- (void)dealloc {
    // set the current context
    [AGLKContext setCurrentContext:((GLKView *)self.view).context];
    
    self.triangleVBO = nil;
    
    // stop using the current context
    ((GLKView *)self.view).context = nil;
    [AGLKContext setCurrentContext:nil];
}

- (void)updateTextureParameters {
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_S
                                       withValue:(self.shouldRepeatTexture) ? GL_REPEAT : GL_CLAMP_TO_EDGE];
    
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_MAG_FILTER
                                       withValue:(self.shouldUseLinearFilter) ? GL_LINEAR : GL_NEAREST];
}

- (void)updateAnimatedVertexPositions {
    if(self.shouldAnimate) {
        for(int i = 0; i < 3; i++) {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if(vertices[i].positionCoords.x >= 1.0f || vertices[i].positionCoords.x <= -1.0f) {
                movementVectors[i].x = -movementVectors[i].x;
            }
            
            vertices[i].positionCoords.y += movementVectors[i].y;
            if(vertices[i].positionCoords.y >= 1.0f || vertices[i].positionCoords.y <= -1.0f) {
                movementVectors[i].y = -movementVectors[i].y;
            }
            
            vertices[i].positionCoords.z += movementVectors[i].z;
            if(vertices[i].positionCoords.z >= 1.0f || vertices[i].positionCoords.z <= -1.0f) {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    } else {
        for(int i = 0; i < 3; i++) {
            vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
        }
    }
    
    for(int i = 0; i < 3; i++) {
        vertices[i].textureCoords.s = (defaultVertices[i].textureCoords.s + self.sCoordinateOffset);
    }
}

- (void)update {
    [self updateAnimatedVertexPositions];
    [self updateTextureParameters];
    
    [self.triangleVBO reInitWithStride:sizeof(SceneVertex)
                      numberOfVertices:sizeof(vertices) / sizeof(vertices[0])
                               andData:vertices];
}

- (IBAction)updatedSCoordinateOffset:(UISlider *)sender {
    [self setSCoordinateOffset:[sender value]];
}

- (IBAction)updatedAnimateState:(UISwitch *)sender {
    [self setShouldAnimate:[sender isOn]];
}

- (IBAction)updatedLinearFilterState:(UISwitch *)sender {
    [self setShouldUseLinearFilter:[sender isOn]];
}

- (IBAction)updatedRepeatFilterState:(UISwitch *)sender {
    [self setShouldRepeatTexture:[sender isOn]];
}
@end
