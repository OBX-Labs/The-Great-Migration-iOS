//
//  PerlinNoise.h
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-05-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#pragma once

#import "Random.h"
#import "GlobalUtils.h"
#import "PreCalcTables.h"

//////////////////////////////////////////////////////////////

// PERLIN NOISE

// [toxi 040903]
// octaves and amplitude amount per octave are now user controlled
// via the noiseDetail() function.

// [toxi 030902]
// cleaned up code and now using bagel's cosine table to speed up

// [toxi 030901]
// implementation by the german demo group farbrausch
// as used in their demo "art": http://www.farb-rausch.de/fr010src.zip

static const int PERLIN_YWRAPB = 4;
static const int PERLIN_YWRAP = 1<<PERLIN_YWRAPB;
static const int PERLIN_ZWRAPB = 8;
static const int PERLIN_ZWRAP = 1<<PERLIN_ZWRAPB;
static const int PERLIN_SIZE = 4095;

//#define PERLIN_SIZE (4095/8)
//#define PERLIN_YWRAPB 4
//#define PERLIN_YWRAP  (1<<PERLIN_YWRAPB)
//#define PERLIN_ZWRAPB 8
//#define PERLIN_ZWRAP  (1<<PERLIN_ZWRAPB)


static int perlin_octaves = 4; // default to medium smooth
static float perlin_amp_falloff = 0.4f; // 50% reduction/octave

// [toxi 031112]
// new vars needed due to recent change of cos table in PGraphics
static int perlin_TWOPI, perlin_PI;
static float* perlin_cosTable;
static float perlin[PERLIN_SIZE+1];

//static Random* perlinRandom = NULL;

static bool resetPerlin = true;


static float noise_fsc(float i) {
    // using bagel's cosine table instead
    return 0.5f*(1.0f-perlin_cosTable[(int)(i*perlin_PI)%perlin_TWOPI]);
}

/**
 * Computes the Perlin noise function value at x, y, z.
 */
static float noise(float x, float y, float z) {
    if (resetPerlin) {
        //*perlin = new float[PERLIN_SIZE + 1];
        for (int i = 0; i < PERLIN_SIZE + 1; i++) {
            perlin[i] = (rand()%100)/50;//perlinRandom->uniform(); //(float)Math.random();
        }
        // [toxi 031112]
        // noise broke due to recent change of cos table in PGraphics
        // this will take care of it
        if(!initCalcTables_flag)
            initCalcTables();
        
        perlin_cosTable = cosLUT;
        perlin_TWOPI = perlin_PI = SINCOS_LENGTH;
        perlin_PI >>= 1;
        
        resetPerlin = !resetPerlin;
    }
    
    if (x<0) x=-x;
    if (y<0) y=-y;
    if (z<0) z=-z;
    
    long xi=(long)x, yi=(long)y, zi=(long)z;
    float xf = (float)(x-xi);
    float yf = (float)(y-yi);
    float zf = (float)(z-zi);
    float rxf, ryf;
    
    float r=0; //0
    float ampl=0.5f; //0.5
    
    float n1,n2,n3;
    
    for (long i=0; i<perlin_octaves; i++) {
        long of=xi+(yi<<PERLIN_YWRAPB)+(zi<<PERLIN_ZWRAPB);
        
        rxf=noise_fsc(xf);
        ryf=noise_fsc(yf);
        
        n1  = perlin[of&PERLIN_SIZE];
        n1 += rxf*(perlin[(of+1)&PERLIN_SIZE]-n1);
        n2  = perlin[(of+PERLIN_YWRAP)&PERLIN_SIZE];
        n2 += rxf*(perlin[(of+PERLIN_YWRAP+1)&PERLIN_SIZE]-n2);
        n1 += ryf*(n2-n1);
        
        of += PERLIN_ZWRAP;
        n2  = perlin[of&PERLIN_SIZE];
        n2 += rxf*(perlin[(of+1)&PERLIN_SIZE]-n2);
        n3  = perlin[(of+PERLIN_YWRAP)&PERLIN_SIZE];
        n3 += rxf*(perlin[(of+PERLIN_YWRAP+1)&PERLIN_SIZE]-n3);
        n2 += ryf*(n3-n2);
        
        n1 += noise_fsc(zf)*(n2-n1);
        
        r += n1*ampl;
        ampl *= perlin_amp_falloff;
        xi<<=1; xf*=2;
        yi<<=1; yf*=2;
        zi<<=1; zf*=2;
        
        if (xf>=1.0f) { xi++; xf--; }
        if (yf>=1.0f) { yi++; yf--; }
        if (zf>=1.0f) { zi++; zf--; }
    }
    return r;
}

/**
 * Computes the Perlin noise function value at point x.
 */
static float noise(float x) {
    // is this legit? it's a dumb way to do it (but repair it later)
    return noise(x, 0.0f, 0.0f);
}

/**
 * Computes the Perlin noise function value at the point x, y.
 */
static float noise(float x, float y) {
    return noise(x, y, 0.0f);
}

// [toxi 031112]
// now adjusts to the size of the cosLUT used via
// the new variables, defined above


// [toxi 040903]
// make perlin noise quality user controlled to allow
// for different levels of detail. lower values will produce
// smoother results as higher octaves are surpressed

static void noiseDetail(int lod) {
    if (lod>0) perlin_octaves=lod;
}

static void noiseDetail(int lod, float falloff) {
    if (lod>0) perlin_octaves=lod;
    if (falloff>0) perlin_amp_falloff=falloff;
}

static void noiseSeed(long what) {
    
    srand ( time(NULL) );
    //srand ( what );
    
    //if (perlinRandom == NULL) perlinRandom = new Random(what);
    //perlinRandom->seedgen(what);
    // force table reset after changing the random number seed [0122]
    resetPerlin = true;
}