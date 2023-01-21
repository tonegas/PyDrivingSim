//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// a_opt_mex_terminate.cpp
//
// Code generation for function 'a_opt_mex_terminate'
//

// Include files
#include "a_opt_mex_terminate.h"
#include "_coder_a_opt_mex_mex.h"
#include "a_opt_mex_data.h"
#include "rt_nonfinite.h"

// Function Definitions
void a_opt_mex_atexit()
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  // Free instance data
  covrtFreeInstanceData(&emlrtCoverageInstance);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void a_opt_mex_terminate()
{
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

// End of code generation (a_opt_mex_terminate.cpp)
