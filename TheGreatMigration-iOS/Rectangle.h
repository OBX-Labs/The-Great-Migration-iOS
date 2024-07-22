#ifndef RECTANGLE
#define RECTANGLE

class Rectangle {

public:
    Rectangle(double _minX =0,double _minY=0,double _minZ=0,float _w=0,float _h=0,float _d=0):
    minX(_minX),
    minY(_minY),
    minZ(_minZ),
    w(_w),
    h(_h),
    d(_d)
    {}
    
    double minX;
    double minY;
    double minZ;
    float w; //width
    float h; //height
    float d; //depth
};

#endif