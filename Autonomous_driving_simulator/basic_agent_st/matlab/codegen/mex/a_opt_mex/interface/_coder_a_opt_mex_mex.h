//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_a_opt_mex_mex.h
//
// Code generation for function '_coder_a_opt_mex_mex'
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
void a_opt_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T nrhs,
                       const mxArray *prhs[7]);

MEXFUNCTION_LINKAGE void mexFunction(int32_T nlhs, mxArray *plhs[],
                                     int32_T nrhs, const mxArray *prhs[]);

emlrtCTX mexFunctionCreateRootTLS();

void pass_primitive_mexFunction(int32_T nlhs, mxArray *plhs[6], int32_T nrhs,
                                const mxArray *prhs[7]);

void pass_primitivej0_mexFunction(int32_T nlhs, mxArray *plhs[3], int32_T nrhs,
                                  const mxArray *prhs[5]);

void stop_primitive_mexFunction(int32_T nlhs, mxArray *plhs[3], int32_T nrhs,
                                const mxArray *prhs[3]);

void stop_primitivej0_mexFunction(int32_T nlhs, mxArray *plhs[3], int32_T nrhs,
                                  const mxArray *prhs[2]);

void v_opt_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T nrhs,
                       const mxArray *prhs[7]);

// End of code generation (_coder_a_opt_mex_mex.h)
