//
//  PerlinTexture.m
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-05-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PerlinTexture.h"
#import "PerlinNoise.h"

@implementation PerlinTexture




// size of the texture
-(id)initWithWidth:(int)Width AndHeight:(int)Height
{
    

    if ((self = [super init]))
    {
        width = Width;
        height = Height;
        //char *tmp[width][height][3];
        perlin = new Perlin(1, 0.028, 1, 2, 0.3);

        //debug
        //maxVal = 10;
        //
        
        texture = new char[width*height*3];
                
        minRange = 50;
        maxRange = 200;
        range = maxRange - minRange;
        
        age = 0;
        ageDir = 1;
        
        //tmpMin = 1;
        //tmpMax = -1;
    }
    return self;
       
}


// for constant animation speed across various devices
//-(char*)getPixels:(double)age Flow:(float)flow
-(char*)getPixels:(double)dt
{
    //pixel index value
    int val = 0;
    
    //update age and limit between change from 0 to 1024 to 0
    age += 10*dt*ageDir;
    if (age > 1024) {
        ageDir = -1;
        age += 10*dt*ageDir;
    }
    else if (ageDir == -1 && age < 0) {
        ageDir = 1;
        age += 10*dt*ageDir;
    }
    
    //update pixels
    for (int x=0;x<width; x++) {

        for (int y=0;y<height; y++) { 
            
            val = 3 * (width * y + x);

            //float noize = (perlin->Get((float)x+age*flow,(float)y,(float)age));
            //noize = ((noize+0.7)/3);
            
            //if (noize > maxVal) {
            //    maxVal = noize;
            //    NSLog(@"%f",noize);
            //}
            
            //texture[val + 0] = (int)(noize*255); //31   //95
            //texture[val + 1] = (int)(noize*255); //147 //211
            //texture[val + 2] = (int)(noize*255); //191
            
            //float p = ;
            //p = (p+0.7)/3;
            //if (p > 1) {
            //    NSLog(@"too much");
            //} else if (p < 0) {
            //    NSLog(@"not enough");
            //}
            
            //if (p < tmpMin) tmpMin = p;
            //if (p > tmpMax) tmpMax = p;
            
            texture[val] = texture[val+1] = texture[val+2] = minRange + (perlin->Get(x*4/*+age*flow*/, y*4, age) + 1) / 2 * range;
            
            //texture[val] = texture[val+1] = texture[val+2] = minRange + perlin->Get(x/20.0f - age, y/20.0f - age/4, age) * range;
        }
    }
    
    
    return &texture[0];
}





@end
