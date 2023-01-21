//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_primitives_api.h
//
// Code generation for function 'a_opt'
//

#ifndef _CODER_PRIMITIVES_API_H
#define _CODER_PRIMITIVES_API_H

// Include files
#include "emlrt.h"
#include "tmwtypes.h"
#include <algorithm>
#include <cstring>

// Variable Declarations
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

// Function Declarations
real_T a_opt(real_T t, real_T v0, real_T a0, real_T sf, real_T vf, real_T af,
             real_T T);

void a_opt_api(const mxArray *const prhs[7], const mxArray **plhs);

void pass_primitive(real_T a0, real_T v0, real_T sf, real_T *v_min,
                    real_T *v_max, real_T t_min, real_T t_max, real_T m1[6],
                    real_T m2[6], real_T *t1, real_T *t2);

void pass_primitive_api(const mxArray *const prhs[7], int32_T nlhs,
                        const mxArray *plhs[6]);

void pass_primitivej0(real_T v0, real_T a0, real_T sf, real_T v_min,
                      real_T v_max, real_T m[6], real_T *tfj0, real_T *vfj0);

void pass_primitivej0_api(const mxArray *const prhs[5], int32_T nlhs,
                          const mxArray *plhs[3]);

void primitives_atexit();

void primitives_initialize();

void primitives_terminate();

void primitives_xil_shutdown();

void primitives_xil_terminate();

void stop_primitive(real_T v0, real_T a0, real_T sf, real_T m[6], real_T *tf,
                    real_T *smax);

void stop_primitive_api(const mxArray *const prhs[3], int32_T nlhs,
                        const mxArray *plhs[3]);

void stop_primitivej0(real_T v0, real_T a0, real_T m[6], real_T *T,
                      real_T *smax);

void stop_primitivej0_api(const mxArray *const prhs[2], int32_T nlhs,
                          const mxArray *plhs[3]);

real_T v_opt(real_T t, real_T v0, real_T a0, real_T sf, real_T vf, real_T af,
             real_T T);

void v_opt_api(const mxArray *const prhs[7], const mxArray **plhs);

#endif
// End of code generation (_coder_primitives_api.h)
