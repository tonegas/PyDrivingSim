//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// pass_primitive.h
//
// Code generation for function 'pass_primitive'
//

#pragma once

// Include files
#include "rtwtypes.h"
#include "covrt.h"
#include "emlrt.h"
#include "mex.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// Function Declarations
void pass_primitive(const emlrtStack *sp, real_T a0, real_T v0, real_T sf,
                    real_T *v_min, real_T *v_max, real_T t_min, real_T t_max,
                    real_T m1[6], real_T m2[6], real_T *t1, real_T *t2);

// End of code generation (pass_primitive.h)
