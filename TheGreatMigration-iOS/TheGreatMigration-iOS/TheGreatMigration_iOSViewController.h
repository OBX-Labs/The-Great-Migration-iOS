//
//  TheGreatMigration_iOSViewController.h
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-04-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "MainController.h"
#import "PerlinTexture.h"



#define PN_WIDTH 64
#define PN_HEIGHT 64




@interface TheGreatMigration_iOSViewController : UIViewController {
@private
    EAGLContext *context;
    GLuint program;
    
    BOOL animating;
    NSInteger animationFrameInterval;
    CADisplayLink *displayLink;
    

    BOOL preCalcTableFlag;
    
    
    double currentTime;
    
    MainController *mainController;        
    
    PerlinTexture *perlinTex;
    
    float counter;
    
    //near and far plane
    GLfloat zNear;
    GLfloat zFar;
    
    //rad theta for field of view Y
    GLfloat radtheta;
    
    //fovY/aspect ratio
    GLfloat fovY;
    GLfloat aspect;
    
    //calculate the x and y min/max
    GLfloat ymax;
    GLfloat ymin;
    GLfloat xmin;
    GLfloat xmax;	
    
    
    
    
    GLuint viewFramebuffer;
    GLuint viewRenderbuffer;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

-(void) fillTex;
- (void)startAnimation;
- (void)stopAnimation;

@end
