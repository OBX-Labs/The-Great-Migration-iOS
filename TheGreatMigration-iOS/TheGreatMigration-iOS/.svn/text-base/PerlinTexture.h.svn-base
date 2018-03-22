//
//  PerlinTexture.h
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-05-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "perlin.h"

@interface PerlinTexture : NSObject {
   
    //debug
    //float maxVal;
    //
    
    
    @private
    
   
    
    int height;
    int width;
    char *texture;
    
    Perlin * perlin;
    
    int minRange;
    int maxRange;
    int range;
    
    double age;
    int ageDir;
    
    //float tmpMin;
    //float tmpMax;
}

// size of the texture
-(id)initWithWidth:(int)Width AndHeight:(int)Height;

// for constant animation speed across various devices
//-(char*)getPixels:(double)age Flow:(float)flow;
-(char*)getPixels:(double)dt;

@end
