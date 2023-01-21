//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// a_opt_mex_initialize.cpp
//
// Code generation for function 'a_opt_mex_initialize'
//

// Include files
#include "a_opt_mex_initialize.h"
#include "_coder_a_opt_mex_mex.h"
#include "a_opt_mex_data.h"
#include "rt_nonfinite.h"

// Function Declarations
static void a_opt_mex_once();

// Function Definitions
static void a_opt_mex_once()
{
  const int32_T postfix_exprs_11_0[3]{0, 1, -3};
  const int32_T postfix_exprs_1_0[3]{0, 1, -3};
  const int32_T postfix_exprs_1_1[3]{0, 1, -3};
  const int32_T postfix_exprs_1_2[3]{0, 1, -3};
  const int32_T postfix_exprs_1_3[3]{0, 1, -3};
  const int32_T postfix_exprs_6_0[3]{0, 1, -3};
  const int32_T postfix_exprs_6_1[3]{0, 1, -3};
  const int32_T postfix_exprs_9_0[3]{0, 1, -2};
  const int32_T cond_ends_11_0[2]{107, 119};
  const int32_T cond_ends_1_0[2]{351, 370};
  const int32_T cond_ends_1_1[2]{516, 535};
  const int32_T cond_ends_1_2[2]{752, 766};
  const int32_T cond_ends_1_3[2]{906, 920};
  const int32_T cond_ends_6_0[2]{213, 231};
  const int32_T cond_ends_6_1[2]{395, 413};
  const int32_T cond_ends_9_0[2]{98, 111};
  const int32_T cond_starts_11_0[2]{101, 113};
  const int32_T cond_starts_1_0[2]{338, 357};
  const int32_T cond_starts_1_1[2]{503, 522};
  const int32_T cond_starts_1_2[2]{742, 756};
  const int32_T cond_starts_1_3[2]{900, 912};
  const int32_T cond_starts_6_0[2]{201, 219};
  const int32_T cond_starts_6_1[2]{383, 401};
  const int32_T cond_starts_9_0[2]{91, 104};
  mex_InitInfAndNan();
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/a_opt.m",
                  0U, 1U, 1U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 0U, 0U, "a_opt", 0, -1, 464);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 0U, 0U, 190, -1, 463);
  // Initialize If Information
  // Initialize MCDC Information
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 0U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/pass_primitive.m",
                  1U, 1U, 9U, 5U, 0U, 0U, 0U, 0U, 0U, 8U, 4U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 1U, 0U, "pass_primitive", 32, -1, 1257);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 1U, 8U, 1133, -1, 1248);
  covrtBasicBlockInit(&emlrtCoverageInstance, 1U, 7U, 930, -1, 1115);
  covrtBasicBlockInit(&emlrtCoverageInstance, 1U, 6U, 826, -1, 881);
  covrtBasicBlockInit(&emlrtCoverageInstance, 1U, 5U, 775, -1, 808);
  covrtBasicBlockInit(&emlrtCoverageInstance, 1U, 4U, 657, -1, 698);
  covrtBasicBlockInit(&emlrtCoverageInstance, 1U, 3U, 553, -1, 623);
  covrtBasicBlockInit(&emlrtCoverageInstance, 1U, 2U, 384, -1, 473);
  covrtBasicBlockInit(&emlrtCoverageInstance, 1U, 1U, 249, -1, 325);
  covrtBasicBlockInit(&emlrtCoverageInstance, 1U, 0U, 146, -1, 231);
  // Initialize If Information
  covrtIfInit(&emlrtCoverageInstance, 1U, 0U, 127, 137, 236, 734);
  covrtIfInit(&emlrtCoverageInstance, 1U, 1U, 334, 371, 482, 726);
  covrtIfInit(&emlrtCoverageInstance, 1U, 2U, 499, 536, 636, 714);
  covrtIfInit(&emlrtCoverageInstance, 1U, 3U, 739, 766, 813, 891);
  covrtIfInit(&emlrtCoverageInstance, 1U, 4U, 896, 921, 1120, 1257);
  // Initialize MCDC Information
  covrtMcdcInit(&emlrtCoverageInstance, 1U, 0U, 337, 371, 2, 0,
                &cond_starts_1_0[0], &cond_ends_1_0[0], 3,
                &postfix_exprs_1_0[0]);
  covrtMcdcInit(&emlrtCoverageInstance, 1U, 1U, 502, 536, 2, 2,
                &cond_starts_1_1[0], &cond_ends_1_1[0], 3,
                &postfix_exprs_1_1[0]);
  covrtMcdcInit(&emlrtCoverageInstance, 1U, 2U, 742, 766, 2, 4,
                &cond_starts_1_2[0], &cond_ends_1_2[0], 3,
                &postfix_exprs_1_2[0]);
  covrtMcdcInit(&emlrtCoverageInstance, 1U, 3U, 899, 921, 2, 6,
                &cond_starts_1_3[0], &cond_ends_1_3[0], 3,
                &postfix_exprs_1_3[0]);
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 1U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/finalOptTime.m",
                  2U, 1U, 1U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 2U, 0U, "finalOptTime", 0, -1, 302);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 2U, 0U, 197, -1, 301);
  // Initialize If Information
  // Initialize MCDC Information
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 2U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/finalOptTimeVel.m",
                  3U, 1U, 1U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 3U, 0U, "finalOptTimeVel", 0, -1, 237);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 3U, 0U, 194, -1, 236);
  // Initialize If Information
  // Initialize MCDC Information
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 3U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/finalOptVel.m",
                  4U, 1U, 1U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 4U, 0U, "finalOptVel", 0, -1, 258);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 4U, 0U, 196, -1, 257);
  // Initialize If Information
  // Initialize MCDC Information
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 4U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/evalPrimitiveCoeffs.m",
                  5U, 1U, 1U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 5U, 0U, "evalPrimitiveCoeffs", 0, -1,
               492);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 5U, 0U, 222, -1, 491);
  // Initialize If Information
  // Initialize MCDC Information
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 5U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/pass_primitivej0.m",
                  6U, 1U, 5U, 2U, 0U, 0U, 0U, 0U, 0U, 4U, 2U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 6U, 0U, "pass_primitivej0", 44, -1, 609);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 6U, 4U, 528, -1, 589);
  covrtBasicBlockInit(&emlrtCoverageInstance, 6U, 3U, 427, -1, 502);
  covrtBasicBlockInit(&emlrtCoverageInstance, 6U, 2U, 330, -1, 370);
  covrtBasicBlockInit(&emlrtCoverageInstance, 6U, 1U, 241, -1, 312);
  covrtBasicBlockInit(&emlrtCoverageInstance, 6U, 0U, 114, -1, 192);
  // Initialize If Information
  covrtIfInit(&emlrtCoverageInstance, 6U, 0U, 197, 232, 317, 609);
  covrtIfInit(&emlrtCoverageInstance, 6U, 1U, 379, 414, 511, 601);
  // Initialize MCDC Information
  covrtMcdcInit(&emlrtCoverageInstance, 6U, 0U, 200, 232, 2, 0,
                &cond_starts_6_0[0], &cond_ends_6_0[0], 3,
                &postfix_exprs_6_0[0]);
  covrtMcdcInit(&emlrtCoverageInstance, 6U, 1U, 382, 414, 2, 2,
                &cond_starts_6_1[0], &cond_ends_6_1[0], 3,
                &postfix_exprs_6_1[0]);
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 6U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/finalOptTimej0.m",
                  7U, 1U, 1U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 7U, 0U, "finalOptTimej0", 0, -1, 370);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 7U, 0U, 201, -1, 369);
  // Initialize If Information
  // Initialize MCDC Information
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 7U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/finalOptVelj0.m",
                  8U, 1U, 1U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 8U, 0U, "finalOptVelj0", 0, -1, 269);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 8U, 0U, 200, -1, 268);
  // Initialize If Information
  // Initialize MCDC Information
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 8U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/stop_primitive.m",
                  9U, 1U, 4U, 2U, 0U, 0U, 0U, 0U, 0U, 2U, 1U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 9U, 0U, "stop_primitive", 33, -1, 514);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 9U, 3U, 461, -1, 506);
  covrtBasicBlockInit(&emlrtCoverageInstance, 9U, 2U, 383, -1, 440);
  covrtBasicBlockInit(&emlrtCoverageInstance, 9U, 1U, 227, -1, 288);
  covrtBasicBlockInit(&emlrtCoverageInstance, 9U, 0U, 121, -1, 172);
  // Initialize If Information
  covrtIfInit(&emlrtCoverageInstance, 9U, 0U, 87, 112, 177, 514);
  covrtIfInit(&emlrtCoverageInstance, 9U, 1U, 190, 214, 297, 452);
  // Initialize MCDC Information
  covrtMcdcInit(&emlrtCoverageInstance, 9U, 0U, 90, 112, 2, 0,
                &cond_starts_9_0[0], &cond_ends_9_0[0], 3,
                &postfix_exprs_9_0[0]);
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 9U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/finalOptTimeStop.m",
                  10U, 1U, 1U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 10U, 0U, "finalOptTimeStop", 0, -1, 264);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 10U, 0U, 203, -1, 263);
  // Initialize If Information
  // Initialize MCDC Information
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 10U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/stop_primitivej0.m",
                  11U, 1U, 2U, 1U, 0U, 0U, 0U, 0U, 0U, 2U, 1U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 11U, 0U, "stop_primitivej0", 45, -1,
               327);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 11U, 1U, 269, -1, 319);
  covrtBasicBlockInit(&emlrtCoverageInstance, 11U, 0U, 129, -1, 251);
  // Initialize If Information
  covrtIfInit(&emlrtCoverageInstance, 11U, 0U, 97, 120, 256, 327);
  // Initialize MCDC Information
  covrtMcdcInit(&emlrtCoverageInstance, 11U, 0U, 100, 120, 2, 0,
                &cond_starts_11_0[0], &cond_ends_11_0[0], 3,
                &postfix_exprs_11_0[0]);
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 11U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/finalOptTimeStopj0.m",
                  12U, 1U, 1U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 12U, 0U, "finalOptTimeStopj0", 0, -1,
               226);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 12U, 0U, 203, -1, 225);
  // Initialize If Information
  // Initialize MCDC Information
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 12U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/finalOptPosj0.m",
                  13U, 1U, 1U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 13U, 0U, "finalOptPosj0", 0, -1, 237);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 13U, 0U, 194, -1, 236);
  // Initialize If Information
  // Initialize MCDC Information
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 13U);
  // Allocate instance data
  covrtAllocateInstanceData(&emlrtCoverageInstance);
  // Initialize Coverage Information
  covrtScriptInit(&emlrtCoverageInstance,
                  "/home/giacomo/University/Autonomous_driving_simulator/"
                  "basic_agent_st/matlab/v_opt.m",
                  14U, 1U, 1U, 0U, 0U, 0U, 0U, 0U, 0U, 0U, 0U);
  // Initialize Function Information
  covrtFcnInit(&emlrtCoverageInstance, 14U, 0U, "v_opt", 0, -1, 484);
  // Initialize Basic Block Information
  covrtBasicBlockInit(&emlrtCoverageInstance, 14U, 0U, 190, -1, 483);
  // Initialize If Information
  // Initialize MCDC Information
  // Initialize For Information
  // Initialize While Information
  // Initialize Switch Information
  // Start callback for coverage engine
  covrtScriptStart(&emlrtCoverageInstance, 14U);
}

void a_opt_mex_initialize()
{
  static const volatile char_T *emlrtBreakCheckR2012bFlagVar{nullptr};
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2022b(&st);
  emlrtClearAllocCountR2012b(&st, false, 0U, nullptr);
  emlrtEnterRtStackR2012b(&st);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    a_opt_mex_once();
  }
}

// End of code generation (a_opt_mex_initialize.cpp)
