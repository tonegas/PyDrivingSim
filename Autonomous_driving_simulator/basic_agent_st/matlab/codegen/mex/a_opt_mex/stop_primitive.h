//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// stop_primitive.h
//
// Code generation for function 'stop_primitive'
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
void stop_primitive(const emlrtStack *sp, real_T v0, real_T a0, real_T sf,
                    real_T m[6], real_T *tf, real_T *smax);

// End of code generation (stop_primitive.h)
