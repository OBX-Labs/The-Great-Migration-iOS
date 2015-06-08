#import "iostream.h"
#import "TessCallback.h"

/**
 * This tesselator callback uses native Processing drawing functions to 
 * execute the incoming commands.
 */

types TessCallback::_types = types();
enders TessCallback::_ends = enders();
vertices TessCallback::_vertices = vertices();

TessData* TessCallback::getData() {
    TessData *data = new TessData(_types, _ends, _vertices);
    
    cout << "TESSDATA" << endl;
    
    for (int i=0;i<data->_vertices.size(); i++) {
        cout << "x:" << data->_vertices[i][0] << " y:" << data->_vertices[i][1] << "z:" << data->_vertices[i][2] << endl;
    }
    
    _types.clear();
    _ends.clear();
    _vertices.clear();
    return data;
}

GLvoid TessCallback::beginCB(GLenum type) {
    //keep track of types
    switch (type) {
        case GL_TRIANGLE_FAN: 
            _types.push_back(GL_TRIANGLE_FAN);
            break;
        case GL_TRIANGLE_STRIP: 
            _types.push_back(GL_TRIANGLE_STRIP);
            break;
        case GL_TRIANGLES: 
            _types.push_back(GL_TRIANGLES);
            break;
    }
}

GLvoid TessCallback::endCB() {
    //keep track of where that series of vertices ends
    _ends.push_back(_vertices.size());
}

GLvoid TessCallback::vertexCB(double *vertex) 
{    
    //glVertex3dv((GLdouble*)vertex);
    //_vertices.push_back((double*)vertex);
    cout << "VERTEXCB -- X:" << vertex[0] << "Y:" << vertex[1] << "Z:" << vertex[2] << endl;
    
    GLdouble *v = new GLdouble[3];
    v[0] = vertex[0];
    v[1] = vertex[1];
    v[2] = vertex[2];
    
    _vertices.push_back(v);
    
}

GLvoid TessCallback::errorCB(GLenum errnum) {
    cout << "ERROR:" << gluErrorString(errnum) << endl;
//    String estring = glu.gluErrorString(errnum);
//    throw new RuntimeException("Tessellation Error: " + estring);
}

/**
 * Implementation of the GLU_TESS_COMBINE callback.
 * @param coords is the 3-vector of the new vertex
 * @param data is the vertex data to be combined, up to four elements.
 * This is useful when mixing colors together or any other
 * user data that was passed in to gluTessVertex.
 * @param weight is an array of weights, one for each element of "data"
 * that should be linearly combined for new values.
 * @param outData is the set of new values of "data" after being
 * put back together based on the weights. it's passed back as a
 * single element Object[] array because that's the closest
 * that Java gets to a pointer.
*/

GLvoid TessCallback::combineCB(GLdouble* coords, GLdouble *vertex_data[4], GLfloat weight[4], GLdouble **outData) {
    GLdouble *vertex = new GLdouble[3];
    vertex[0] = coords[0];
    vertex[1] = coords[1];
    vertex[2] = coords[2];
    
    outData[0] = vertex;//vertex;//[0] = ;
//    outData[0][1] = vertex[1];
//    outData[0][2] = vertex[2];
}
