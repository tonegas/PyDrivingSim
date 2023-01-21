//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// main.cpp
//
// Code generation for function 'main'
//

/*************************************************************************/
/* This automatically generated example C++ main file shows how to call  */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

// Include files
#include "main.h"
#include "primitives.h"
#include "rt_nonfinite.h"

// Function Declarations
static double argInit_real_T();

// Function Definitions
static double argInit_real_T()
{
  return 0.0;
}

int main(int, char **)
{
  // The initialize function is being called automatically from your entry-point
  // function. So, a call to initialize is not included here. Invoke the
  // entry-point functions.
  // You can call entry-point functions multiple times.
  main_a_opt();
  main_pass_primitive();
  main_pass_primitivej0();
  main_stop_primitive();
  main_stop_primitivej0();
  main_v_opt();
  // Terminate the application.
  // You do not need to do this more than one time.
  primitives_terminate();
  return 0;
}

void main_a_opt()
{
  double t_tmp;
  // Initialize function 'a_opt' input arguments.
  t_tmp = argInit_real_T();
  // Call the entry-point 'a_opt'.
  t_tmp = a_opt(t_tmp, t_tmp, t_tmp, t_tmp, t_tmp, t_tmp, t_tmp);
}

void main_pass_primitive()
{
  double m1[6];
  double m2[6];
  double a0_tmp;
  double t1;
  double t2;
  double v_max;
  double v_min;
  // Initialize function 'pass_primitive' input arguments.
  a0_tmp = argInit_real_T();
  // Call the entry-point 'pass_primitive'.
  v_min = a0_tmp;
  v_max = a0_tmp;
  pass_primitive(a0_tmp, a0_tmp, a0_tmp, &v_min, &v_max, a0_tmp, a0_tmp, m1, m2,
                 &t1, &t2);
}

void main_pass_primitivej0()
{
  double m[6];
  double tfj0;
  double v0_tmp;
  double vfj0;
  // Initialize function 'pass_primitivej0' input arguments.
  v0_tmp = argInit_real_T();
  // Call the entry-point 'pass_primitivej0'.
  pass_primitivej0(v0_tmp, v0_tmp, v0_tmp, v0_tmp, v0_tmp, m, &tfj0, &vfj0);
}

void main_stop_primitive()
{
  double m[6];
  double smax;
  double tf;
  double v0_tmp;
  // Initialize function 'stop_primitive' input arguments.
  v0_tmp = argInit_real_T();
  // Call the entry-point 'stop_primitive'.
  stop_primitive(v0_tmp, v0_tmp, v0_tmp, m, &tf, &smax);
}

void main_stop_primitivej0()
{
  double m[6];
  double T;
  double smax;
  double v0_tmp;
  // Initialize function 'stop_primitivej0' input arguments.
  v0_tmp = argInit_real_T();
  // Call the entry-point 'stop_primitivej0'.
  stop_primitivej0(v0_tmp, v0_tmp, m, &T, &smax);
}

void main_v_opt()
{
  double t_tmp;
  // Initialize function 'v_opt' input arguments.
  t_tmp = argInit_real_T();
  // Call the entry-point 'v_opt'.
  t_tmp = v_opt(t_tmp, t_tmp, t_tmp, t_tmp, t_tmp, t_tmp, t_tmp);
}

// End of code generation (main.cpp)
