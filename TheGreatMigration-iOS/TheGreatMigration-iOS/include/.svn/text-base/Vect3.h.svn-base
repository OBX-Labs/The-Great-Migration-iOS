#pragma once


#ifndef VECT3_H
#define VECT3_H

#import <math.h>
//#include <iostream>

class Vect3 {
	
public:
	Vect3(double x=0, double y=0, double z=0);
	double x,y,z;

	static Vect3 vect_neg(Vect3 v);
    
	static double vect_magnitude(Vect3 v);
    double mag();
    
	static Vect3 vect_normalize(Vect3 v);
	static double vect_sqrmag(Vect3 v);
    static Vect3 vect_project(Vect3 a, Vect3 b);
    
	static double vect_dot(Vect3 a, Vect3 b);
   	static double vect_dot(Vect3 *a, Vect3 *b);
    
	static int vect_equal(Vect3 a, Vect3 b);
	static Vect3 vect_cross(Vect3 a, Vect3 b);

	static Vect3 vect_add(Vect3 a, Vect3 b);
	static Vect3 vect_sub(Vect3 a, Vect3 b);
	static Vect3 vect_mul(Vect3 v, double s);
	static Vect3 vect_div(Vect3 v, double s);
    
	static Vect3 interpolateV(Vect3 a, Vect3 b, double t);
	static double interpolate(double a, double b, double t);

    
    
    void rotateXY(Vect3 around, float angle);
    void translate(Vect3 by);
    
    
    
    /*
     MEMBER OPERATORS
     */
    
    Vect3 &operator= (const Vect3& other)
    {
        if (this != &other) // protect against invalid self-assignment
        {
            x = other.x;
            y = other.y;
            z = other.z;
        }
        
        return *this;
    }
    
    void operator+(Vect3 *u){ vect_add(u); }
    
    void operator*(double s){ vect_mul(s); }
    void operator*(float s){ vect_mul(s); }	
    
    void operator/(double s){ vect_div(s); }
    void operator/(float s){ vect_div(s); }

    void operator-(Vect3 *v){ vect_sub(v); }	
    
private:
    void vect_add(Vect3 *a);
    void vect_sub(Vect3 *a);
    void vect_mul(double s);
    void vect_div(double s);
    
};

/*
 STATIC OPERATORS
 */
Vect3 operator+(Vect3 u, Vect3 v);	
Vect3 operator*(Vect3 u, double s);	
Vect3 operator/(Vect3 u, double s);	
Vect3 operator-(Vect3 u, Vect3 v);	
//std::ostream &operator<<(std::ostream &stream, Vect3 v);

#endif