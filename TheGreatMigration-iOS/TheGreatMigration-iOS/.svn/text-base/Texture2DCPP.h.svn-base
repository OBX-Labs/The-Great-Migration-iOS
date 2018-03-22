//
//  Texture2D.h
//  TheGreatMigration-iOS
//
//  Created by Charles-Antoine Dupont on 11-07-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <OpenGLES/ES1/gl.h>

class Texture2D 
{
public:
	Texture2D(int id, int width, int height)
    {
        _textureId = id; _width = width; _height = height;
    }
    
	virtual ~Texture2D(void)
    {
        // Delete Texture from HGL Memory
        glDeleteTextures(1, ((GLuint*)&_textureId));
    }
	int  getTextureId() {return _textureId; }
protected:
	int _textureId;   // The reference ID of the texture in OpenGL memory
    int _width;
    int _height;
};