#include "vect3.h"

Vect3::Vect3(double _x,double _y,double _z): x(_x), y(_y), z(_z)
{
	
}

//std::ostream &operator<<(std::ostream &stream, Vect3 v)
//{
//	stream << "(" << v.x << "," << v.y << "," << v.z << ")";
//	return stream;
//}

Vect3 Vect3::vect_add(Vect3 a, Vect3 b)
{
    return Vect3 (a.x + b.x, a.y + b.y, a.z + b.z);
}
void Vect3::vect_add(Vect3 *a)
{
    x += a->x;
    y += a->y;
    z += a->z;
}


Vect3 Vect3::vect_sub(Vect3 a, Vect3 b)
{
    return Vect3 (a.x - b.x, a.y - b.y, a.z - b.z);
}
void Vect3::vect_sub(Vect3 *a)
{
    x -= a->x;
    y -= a->y;
    z -= a->z;
}


Vect3 Vect3::vect_neg(Vect3 v)
{
    return Vect3 (-v.x, -v.y, -v.z);
}

Vect3 Vect3::vect_mul(Vect3 v, double s)
{
    return Vect3 (v.x * s, v.y * s, v.z * s);
}
void Vect3::vect_mul(double s)
{
    x *= s;
    y *= s;
    z *= s;
}


Vect3 Vect3::vect_div(Vect3 v, double s)
{
    return Vect3 (v.x / s, v.y / s, v.z / s);
}
void Vect3::vect_div(double s)
{
    x /= s;
    y /= s;
    z /= s;
}


double Vect3::vect_dot(Vect3 a, Vect3 b)
{
    return a.x * b.x + a.y * b.y + a.z * b.z;
}
double Vect3::vect_dot(Vect3 *a, Vect3 *b)
{
    return a->x * b->x + a->y * b->y + a->z * b->z;
}

double Vect3::vect_sqrmag(Vect3 v)
{
    return vect_dot(v, v);
}

int Vect3::vect_equal(Vect3 a, Vect3 b)
{
    return a.x == b.x && a.y == b.y && a.z == b.z;
}

Vect3 Vect3::vect_cross(Vect3 a, Vect3 b)
{
    return Vect3(
					 a.y*b.z - a.z*b.y,
					 a.z*b.x - a.x*b.z,
					 a.x*b.y - a.y*b.x);
}

double Vect3::vect_magnitude(Vect3 v)
{
    return sqrt(vect_dot(v, v));
}
double Vect3::mag()
{
    return sqrt(vect_dot(this, this));
}


Vect3 Vect3::vect_normalize(Vect3 v)
{
	if (v.x == 0 && v.y == 0 && v.z == 0) {
		return v;
	}

    return vect_div(v, vect_magnitude(v));
}

Vect3 Vect3::vect_project(Vect3 a, Vect3 b)
{
    return vect_mul(b, vect_dot(a, b) / vect_sqrmag(b));
}

Vect3 Vect3::interpolateV(Vect3 a, Vect3 b, double t)
{
	
	double x = interpolate(a.x,b.x,t);
	double y = interpolate(a.y,b.y,t);
	double z = interpolate(a.z,b.z,t);
	
	return  Vect3(x,y,z);
}

double Vect3::interpolate(double a, double b, double t)
{
	return  a+(b-a)*t;
}





/************************************
 *  AFFINE TRANSFORMATION
 ************************************/

void Vect3::rotateXY(Vect3 around, float angle)
{
    x = x*cos(angle)+y*sin(angle);
    y = -x*sin(angle)+y*cos(angle);
}

void Vect3::translate(Vect3 by)
{
    x = x+by.x;
    y = y+by.y;
    z = z+by.z;
}

/************************************
 *  END AFFINE TRANSFORMATION
 ************************************/





Vect3 operator+(Vect3 u, Vect3 v)
{
	return Vect3::vect_add(u,v);
}

Vect3 operator*(Vect3 v, double s)
{
	return Vect3::vect_mul(v, s);
}

Vect3 operator/(Vect3 v, double s)
{
	return Vect3::vect_div(v, s);	
}

Vect3 operator-(Vect3 u, Vect3 v)
{
	return Vect3::vect_sub(u, v);
}
