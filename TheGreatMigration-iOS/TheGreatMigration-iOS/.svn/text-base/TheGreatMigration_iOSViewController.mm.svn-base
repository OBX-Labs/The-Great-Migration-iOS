//
//  TheGreatMigration_iOSViewController.m
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-04-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "TheGreatMigration_iOSViewController.h"
#import "EAGLView.h"
#import <iostream.h>

#import "PreCalcTables.h"


// Uniform index.
enum {
    UNIFORM_TRANSLATE,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};

@interface TheGreatMigration_iOSViewController ()
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) CADisplayLink *displayLink;
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation TheGreatMigration_iOSViewController

@synthesize animating, context, displayLink;

- (void)awakeFromNib
{
    EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
//    if ([context API] == kEAGLRenderingAPIOpenGLES2)
//        [self loadShaders];
    
//    if (!aContext) {
        aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
//    }
    
    if (!aContext)
        NSLog(@"Failed to create ES context");
    else if (![EAGLContext setCurrentContext:aContext])
        NSLog(@"Failed to set ES context current");
    
	self.context = aContext;
	[aContext release];
    
    
    
    //near and far plane
    zNear = 0.1;
    zFar = 10;
    
    //rad theta for field of view Y
    radtheta = 2.0 * atan2(768.0f/2, zNear);
    
    //fovY/aspect ratio
    fovY = (100.0 * radtheta) / M_PI;
    aspect = 1024.0f/768.0f;
    
    //calculate the x and y min/max
    ymax = zNear * tan(fovY * M_PI / 360.0);
    ymin = -ymax;
    xmin = ymin * aspect;
    xmax = ymax * aspect;	
    
    
    [(EAGLView *)self.view setContext:context];
    [(EAGLView *)self.view setFramebuffer];
    
    
    currentTime = [NSDate timeIntervalSinceReferenceDate];
    counter = 0;
    
    
    mainController = [[MainController alloc] initWithWidth:1024 Height:768];
    
    if (!initCalcTables_flag) {
        initCalcTables();
    }
    
    if (!perlinTex) {
        perlinTex = [[PerlinTexture alloc] initWithWidth:PN_WIDTH AndHeight:PN_HEIGHT];
    }
    
    
    
    animating = FALSE;
    animationFrameInterval = 1;
    self.displayLink = nil;
}


- (void)dealloc
{
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }
    
    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
    [context release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self startAnimation];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAnimation];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }

    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	self.context = nil;	
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
    if (frameInterval >= 1) {
        animationFrameInterval = frameInterval;
        
        if (animating) {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating) {
        CADisplayLink *aDisplayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(drawFrame)];
        [aDisplayLink setFrameInterval:animationFrameInterval];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink = aDisplayLink;
        
        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        animating = FALSE;
    }
}


- (void)drawFrame
{
    [(EAGLView *)self.view setFramebuffer];
    
    
    currentTime = [NSDate timeIntervalSinceReferenceDate];

    
    float yCoord1 = 768/1024;
    
    // Replace the implementation of this method to do your own custom drawing.
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    
    static const GLfloat perlinTexCoord[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f,  0.0f,
        1.0f,  1.0f,
    };
    
    static const GLubyte squareColors[] = {
        255};/*, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
    };*/
    
    
    static float transY = 0.0f;
    
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    if ([context API] == false) { //kEAGLRenderingAPIOpenGLES2
        
     /****************************************************
      * OGL ES2
      ****************************************************/
        
        // Use shader program.
        glUseProgram(program);
        
        // Update uniform value.
        glUniform1f(uniforms[UNIFORM_TRANSLATE], (GLfloat)transY);
        transY += 0.075f;	

//        Update attribute values.
//        glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
//        glEnableVertexAttribArray(ATTRIB_VERTEX);
//        glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, 1, 0, squareColors);
//        glEnableVertexAttribArray(ATTRIB_COLOR);
        
        

        
        
        // Validate program before drawing. This is a good check, but only really necessary in a debug build.
        // DEBUG macro must be defined in your debug configurations if that's not already the case.
    #if defined(DEBUG)
        if (![self validateProgram:program]) {
            NSLog(@"Failed to validate program: %d", program);
            return;
        }
    #endif
    } else {
        
    /****************************************************
     * OGL ES1
     ****************************************************/

		
        //set the view port/projection mode
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();

        

        //frustrum and translate to center
        glFrustumf(xmin, xmax, ymin, ymax, zNear, zFar);

        glTranslatef(0, 0, -1);
        
        glMatrixMode(GL_MODELVIEW);
        //glLoadIdentity();
        
        
        
        //glTranslatef(0.0f, (GLfloat)(sinf(transY)/2.0f), 0.0f);
        //transY += 0.075f;
        
        
//        glEnable (GL_TEXTURE_2D);
//        
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//        
//        //avoid weird edges
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);        
//        
//        glTexImage2D (
//                      GL_TEXTURE_2D,
//                      0,
//                      GL_RGB,
//                      PN_WIDTH,
//                      PN_HEIGHT,
//                      0,
//                      GL_RGB,
//                      GL_UNSIGNED_BYTE,
//                      [perlinTex getPixels:counter Flow:1.0f]
//                      );
//        //counter = counter+10000000;
//        counter += 0.4;
//        
//        glVertexPointer(2, GL_FLOAT, 0, squareVertices);
//        glEnableClientState(GL_VERTEX_ARRAY);
//        //glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
//        //glEnableClientState(GL_COLOR_ARRAY);
//        glTexCoordPointer(2,GL_FLOAT,0,perlinTexCoord);        
//        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        
    }
//    
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//    glDisable(GL_TEXTURE_2D);
//    
//    
//    
    
    
    NSMutableArray *beasts = [mainController beasts];
    Beast *beast;
    
    for (int a =0; a<[beasts count]; a++) {
        
        beast = [beasts objectAtIndex:a];
        
        glPushMatrix();
        
//        glTranslatef([beast pos]->x, [beast pos]->y, [beast pos]->z); 
//        glRotatef([beast rot] + (PI-[beast forward]),0,0,1);        

            //draw glypsh  
            TessDatas *datas = [beast getData];
             for(int i = 0; i < datas.size(); i++) {
                 TessData *data = datas[i];
             
                 int datasSize = datas.size(); 
                 
             //            fr = red(data->fill);
             //            fg = green(data.fill);
             //            fb = blue(data.fill);
             //            fa = alpha(data.fill);
             //            
             //            if (camouflage != 0) {
             //                fr += (CAMOUFLAGE_RED-fr)*camouflage;
             //                fg += (CAMOUFLAGE_GREEN-fg)*camouflage;
             //                fb += (CAMOUFLAGE_BLUE-fb)*camouflage;
             //                fa += (CAMOUFLAGE_ALPHA-fa)*camouflage;
             //            }
             //            
             //            fill(fr, fg, fb, fa);
             
             
             //GLfloat vertices[3];
             
              //NSLog(@"DRAW BEAST");   
                 
             //go through contours
             for(int j = 0; j < data->_types.size(); j++) {
             //beginShape(data->_types[j]);
             //go through vertices

                 //int typeSize = data->_types.size();
               
                 GLfloat vertices[(data->_ends[j]-data->_ends[j-1])*2];
                 int iterator = 0;
                 
                 for(int k = j==0?0:data->_ends[j-1]; k < data->_ends[j]; k++) {
             
                     //int endSize = data->_ends.size();
                 
//                     GLfloat vertices[] = {
//                         -1.0f, -1.0f,
//                         1.0f, -1.0f,
//                         -1.0f,  1.0f,
//                         1.0f,  1.0f,
//                     };    
                 
                     vertices[iterator] = data->_vertices[k][0]/3000; //{k/data->_types.size(),k/data->_types.size(),k/data->_types.size()};//
                     vertices[iterator+1] = data->_vertices[k][1]/3000;
                     //vertices[iterator+2] = data->_vertices[k][2]/3000;
                     
                     //cout << " " << vertices[iterator]*100 << "," << vertices[iterator+1]*100;
                       NSLog(@"%f,%f", vertices[iterator], vertices[iterator+1]);
             
                     iterator += 2;
                 

                     
                 }
                 glVertexPointer(2, GL_FLOAT, 0, vertices);
                 glEnableClientState(GL_VERTEX_ARRAY);
                 glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                 glEnableClientState(GL_COLOR_ARRAY);
                 
                 glDrawArrays(data->_types[j], 0, (data->_ends[j]-data->_ends[j-1])*2);
                 
                 
//                 //ERROR HANDLING
//                 GLenum gl_error = glGetError();
//                 if(gl_error != GL_NO_ERROR)
//                 {
//                     NSLog(@"OpenGL error %d: %s\n", gl_error, gluErrorString(gl_error));
//                     abort();
//                 }

                 //data->_types[j==0?0:j-1]
             //endShape();  
             }
        
             //data->_types.    
                 
                 //cout << endl;
        }
        
        

        
        NSLog(@"DRAW ITERATION OVER.");
            
            
//            GLfloat vertices[] = {
//                -1.0f, -1.0f,
//                1.0f, -1.0f,
//                -1.0f,  1.0f,
//                1.0f,  1.0f,
//            };
//            
//            glVertexPointer(2, GL_FLOAT, 0, vertices);
//            glEnableClientState(GL_VERTEX_ARRAY);
//            glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
//            glEnableClientState(GL_COLOR_ARRAY);
//            
//            glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            
        
            //glDisableClientState( GL_VERTEX_ARRAY );
        //}
                
        glPopMatrix();
        
    }
    
    
    
    
    glDisableClientState( GL_VERTEX_ARRAY );
	glDisableClientState( GL_TEXTURE_COORD_ARRAY );
    
    


    
    
    
    [(EAGLView *)self.view presentFramebuffer];
}







- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(program, ATTRIB_COLOR, "color");
    
    // Link program.
    if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program)
        {
            glDeleteProgram(program);
            program = 0;
        }
        
        return FALSE;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_TRANSLATE] = glGetUniformLocation(program, "translate");
    
    // Release vertex and fragment shaders.
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);
    
    return TRUE;
}

@end