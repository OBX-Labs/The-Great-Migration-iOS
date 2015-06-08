


#ifndef TESSCALLBACK_H
#define TESSCALLBACK_H

#import <iostream>
#import "TessData.h"
#import "glu.h"

#import <stdio.h>

class TessCallback {

public:
    
    static TessData* getData();

    static types _types;        //types of tesselated shape
    static enders _ends;         //index of end vertices
    static vertices _vertices; //array of vertices
    
    static GLvoid beginCB(GLenum type);
    static GLvoid endCB();
    static GLvoid vertexCB(double *data);
    static GLvoid errorCB(GLenum errnum);
    static GLvoid combineCB(GLdouble* coords, GLdouble *vertex_data[4], GLfloat weight[4], GLdouble **outData);

};

#endif