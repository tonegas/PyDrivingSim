//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// primitives.h
//
// Code generation for function 'primitives'
//

#ifndef PRIMITIVES_H
#define PRIMITIVES_H

// Include files
#include "rtwtypes.h"
#include <cstddef>
#include <cstdlib>

// Function Declarations
extern double a_opt(double t, double v0, double a0, double sf, double vf,
                    double af, double T);

extern void pass_primitive(double a0, double v0, double sf, double *v_min,
                           double *v_max, double t_min, double t_max,
                           double m1[6], double m2[6], double *t1, double *t2);

extern void pass_primitivej0(double v0, double a0, double sf, double v_min,
                             double v_max, double m[6], double *tfj0,
                             double *vfj0);

extern void primitives_initialize();

extern void primitives_terminate();

extern void stop_primitive(double v0, double a0, double sf, double m[6],
                           double *tf, double *smax);

extern void stop_primitivej0(double v0, double a0, double m[6], double *T,
                             double *smax);

extern double v_opt(double t, double v0, double a0, double sf, double vf,
                    double af, double T);

#endif
// End of code generation (primitives.h)
