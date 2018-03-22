# include <math.h>
#import <iostream>
#import <sstream>
#import "MainSettings.h"
#import <string>
#import <iomanip>

#import "Texture2DCPP.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

//adjacent/cos30
static double screenX(double X, double Y, double Z)
{
    return (X/Z)*1153.5458;
}

static double screenY(double X, double Y, double Z)
{
    return (Y/Z)*1153.5458;//+382;
}

static double screenZ(double X, double Y, double Z)
{
    return Z;
}

static float bezierPoint(float a, float b, float c, float d, float t) 
{
    float t1 = 1.0f - t;
    return a*t1*t1*t1 + 3*b*t*t1*t1 + 3*c*t*t*t1 + d*t*t*t;
}


//static float rotate(float x,float y,float z)
//{
//    
//}



static std::stringstream polyLine;
static std::stringstream circles;
static char brightness;

static std::string getHexCode(unsigned char c) {
    
    // Not necessarily the most efficient approach,
    // creating a new stringstream each time.
    // It'll do, though.
    std::stringstream ss;
    
    // Set stream modes
    ss << std::uppercase << std::setw(2) << std::setfill('0') << std::hex;
    
    // Stream in the character's ASCII code
    // (using `+` for promotion to `int`)
    ss << +c;
    
    // Return resultant string content
    return ss.str();
}

static std::string toSVG(float x,float y, int color)
{
    
    std::stringstream rtrnVal;
    
    rtrnVal << "<circle cx='"<< x <<"' cy='"<< y <<"' r='3' stroke='black' stroke-width='1' fill='#";
    if(color ==1 )
        rtrnVal << std::hex << getHexCode(brightness) << getHexCode(brightness) << getHexCode(brightness);
    else if(color == 2)
        rtrnVal << "FF0000";
    else if (color == 3)
        rtrnVal << "000000";
    else if(color == 4)
        rtrnVal << "FFFFFF";
    else if (color == 5)
        rtrnVal << "00FF00";
        rtrnVal << "'/>";
        
    brightness = brightness+14%255;
    polyLine << " "<< x << "," << y;
    
    return rtrnVal.str();

}
static void printSVG()
{
    brightness = 0;
    std::cout << polyLine.str() << "' style='fill:none;stroke:blue;stroke-width:1'/>" << circles.str() << std::endl << "---------" << std::endl;
    polyLine.str(std::string());
    circles.str(std::string());
    polyLine << "<polyline points='";
}


static Texture2D* LoadImage(std::string imagefile, std::string type )
{
    //glEnable(GL_TEXTURE_2D);
    // Id for texture
	GLuint texture;	
    // Generate textures
	glGenTextures(1, &texture); 
	// Bind it
	glBindTexture(GL_TEXTURE_2D, texture);
	// Set a few parameters to handle drawing the image at lower and higher sizes than original
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    
    
	NSString *resource = [[NSString alloc] initWithUTF8String:imagefile.c_str()];
  	NSString *_type = [[NSString alloc] initWithUTF8String:type.c_str()];
    
    NSString* path = [[NSBundle mainBundle] pathForResource: resource ofType: _type];
    
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
    if (image == nil)
        return NULL;	
    // Get Image size
    GLuint width = CGImageGetWidth(image.CGImage);
    GLuint height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Allocate memory for image
    void *imageData = malloc( height * width * 4 );
    CGContextRef imgcontext = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( imgcontext, CGRectMake( 0, 0, width, height ) );
    CGContextTranslateCTM( imgcontext, 0, height - height );
    CGContextDrawImage( imgcontext, CGRectMake( 0, 0, width, height ), image.CGImage );

    // Generate texture in opengl
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
	// Release context
	CGContextRelease(imgcontext);
	// Free Stuff
    //free(imageData);
    
    //project now ARC, no need to release
    /*
    [image release];
    [texData release];
    */
    
    NSLog(@"DA TEXTURE ID : %d",texture);
    
    // Create and return texture
    Texture2D* tex = new Texture2D(texture,width, height);
    return tex;
}


//generate random value between 0 and MAX
static inline float randomf(float from, float to)
{
    return from+fmod(arc4random(),(to-from));
}
//static void printOUTLINE(FT_Outline *outline)
//{
//    int color = 1;
//    
//    printSVG();
//    for (int i =0; i<outline->n_points; i++) 
//    {
//        if ((outline->tags[i])&1) 
//            color =4;
//        else
//            color =3;
//        
//        std::cout << toSVG((outline->points[i].x/5)+20, (outline->points[i].y/5)+20, color);
//    }
//    printSVG();
//    
//}

