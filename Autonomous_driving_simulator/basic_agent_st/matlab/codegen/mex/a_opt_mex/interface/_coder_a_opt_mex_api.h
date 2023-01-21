//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_a_opt_mex_api.h
//
// Code generation for function '_coder_a_opt_mex_api'
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
void a_opt_api(const mxArray *const prhs[7], const mxArray **plhs);

void pass_primitive_api(const mxArray *const prhs[7], int32_T nlhs,
                        const mxArray *plhs[6]);

void pass_primitivej0_api(const mxArray *const prhs[5], int32_T nlhs,
                          const mxArray *plhs[3]);

void stop_primitive_api(const mxArray *const prhs[3], int32_T nlhs,
                        const mxArray *plhs[3]);

void stop_primitivej0_api(const mxArray *const prhs[2], int32_T nlhs,
                          const mxArray *plhs[3]);

void v_opt_api(const mxArray *const prhs[7], const mxArray **plhs);

// End of code generation (_coder_a_opt_mex_api.h)
