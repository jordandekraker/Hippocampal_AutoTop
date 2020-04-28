/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sort1.c
 *
 * Code generation for function 'sort1'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "laplace_iters.h"
#include "sort1.h"
#include "laplace_iters_emxutil.h"
#include "sortIdx.h"
#include "eml_int_forloop_overflow_check.h"
#include "laplace_iters_data.h"

/* Variable Definitions */
static emlrtRSInfo l_emlrtRSI = { 76,  /* lineNo */
  "sort",                              /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/sort.m"/* pathName */
};

static emlrtRSInfo m_emlrtRSI = { 79,  /* lineNo */
  "sort",                              /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/sort.m"/* pathName */
};

static emlrtRSInfo n_emlrtRSI = { 81,  /* lineNo */
  "sort",                              /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/sort.m"/* pathName */
};

static emlrtRSInfo o_emlrtRSI = { 84,  /* lineNo */
  "sort",                              /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/sort.m"/* pathName */
};

static emlrtRSInfo p_emlrtRSI = { 87,  /* lineNo */
  "sort",                              /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/sort.m"/* pathName */
};

static emlrtRSInfo q_emlrtRSI = { 90,  /* lineNo */
  "sort",                              /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/sort.m"/* pathName */
};

static emlrtRTEInfo y_emlrtRTEI = { 1, /* lineNo */
  20,                                  /* colNo */
  "sort",                              /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/sort.m"/* pName */
};

static emlrtRTEInfo qb_emlrtRTEI = { 56,/* lineNo */
  1,                                   /* colNo */
  "sort",                              /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/sort.m"/* pName */
};

/* Function Definitions */
void sort(const emlrtStack *sp, emxArray_real_T *x)
{
  int32_T dim;
  int32_T i8;
  emxArray_real_T *vwork;
  int32_T j;
  int32_T vstride;
  int32_T k;
  emxArray_int32_T *dd_emlrtRSI;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  dim = 2;
  if (x->size[0] != 1) {
    dim = 1;
  }

  if (dim <= 1) {
    i8 = x->size[0];
  } else {
    i8 = 1;
  }

  emxInit_real_T1(sp, &vwork, 1, &qb_emlrtRTEI, true);
  j = vwork->size[0];
  vwork->size[0] = i8;
  emxEnsureCapacity_real_T2(sp, vwork, j, &y_emlrtRTEI);
  st.site = &l_emlrtRSI;
  vstride = 1;
  k = 1;
  while (k <= dim - 1) {
    vstride *= x->size[0];
    k = 2;
  }

  st.site = &m_emlrtRSI;
  st.site = &n_emlrtRSI;
  if ((!(1 > vstride)) && (vstride > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  j = 0;
  emxInit_int32_T(sp, &dd_emlrtRSI, 1, &y_emlrtRTEI, true);
  while (j + 1 <= vstride) {
    st.site = &o_emlrtRSI;
    if ((!(1 > i8)) && (i8 > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (k = 0; k < i8; k++) {
      vwork->data[k] = x->data[j + k * vstride];
    }

    st.site = &p_emlrtRSI;
    sortIdx(&st, vwork, dd_emlrtRSI);
    st.site = &q_emlrtRSI;
    for (k = 0; k < i8; k++) {
      x->data[j + k * vstride] = vwork->data[k];
    }

    j++;
  }

  emxFree_int32_T(sp, &dd_emlrtRSI);
  emxFree_real_T(sp, &vwork);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (sort1.c) */
