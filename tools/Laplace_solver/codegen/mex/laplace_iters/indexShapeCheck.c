/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * indexShapeCheck.c
 *
 * Code generation for function 'indexShapeCheck'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "laplace_iters.h"
#include "indexShapeCheck.h"

/* Variable Definitions */
static emlrtRSInfo oc_emlrtRSI = { 14, /* lineNo */
  "indexShapeCheck",                   /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/indexShapeCheck.m"/* pathName */
};

static emlrtRSInfo pc_emlrtRSI = { 80, /* lineNo */
  "indexShapeCheck",                   /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/indexShapeCheck.m"/* pathName */
};

static emlrtRTEInfo jc_emlrtRTEI = { 88,/* lineNo */
  9,                                   /* colNo */
  "indexShapeCheck",                   /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/indexShapeCheck.m"/* pName */
};

/* Function Definitions */
void indexShapeCheck(const emlrtStack *sp, const int32_T matrixSize[3], int32_T
                     indexSize)
{
  boolean_T nonSingletonDimFound;
  boolean_T guard1 = false;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  nonSingletonDimFound = false;
  if (matrixSize[0] != 1) {
    nonSingletonDimFound = true;
  }

  guard1 = false;
  if (matrixSize[1] != 1) {
    if (nonSingletonDimFound) {
      nonSingletonDimFound = false;
    } else {
      nonSingletonDimFound = true;
      guard1 = true;
    }
  } else {
    guard1 = true;
  }

  if (guard1 && (matrixSize[2] != 1)) {
    if (nonSingletonDimFound) {
      nonSingletonDimFound = false;
    } else {
      nonSingletonDimFound = true;
    }
  }

  if (nonSingletonDimFound) {
    nonSingletonDimFound = false;
    if (indexSize != 1) {
      nonSingletonDimFound = true;
    }

    if (nonSingletonDimFound) {
      st.site = &oc_emlrtRSI;
      if (((matrixSize[0] == 1) != (indexSize == 1)) || (matrixSize[1] != 1)) {
        nonSingletonDimFound = true;
      } else {
        nonSingletonDimFound = false;
        if (matrixSize[2] != 1) {
          nonSingletonDimFound = true;
        }
      }

      b_st.site = &pc_emlrtRSI;
      if (nonSingletonDimFound) {
        emlrtErrorWithMessageIdR2018a(&b_st, &jc_emlrtRTEI,
          "Coder:FE:PotentialMatrixMatrix", "Coder:FE:PotentialMatrixMatrix", 0);
      }
    }
  }
}

/* End of code generation (indexShapeCheck.c) */
