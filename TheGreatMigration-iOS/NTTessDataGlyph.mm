//
//  NTTessDataGlyph.m
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-06-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NTTessDataGlyph.h"


NTTessDataGlyph::NTTessDataGlyph(char c, TessData *data):NTGlyph(c)
{
    _data = data;
};

NTTessDataGlyph::~NTTessDataGlyph(){};

TessData* NTTessDataGlyph::getData()
{
    return _data;
};