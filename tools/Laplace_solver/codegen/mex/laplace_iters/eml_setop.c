/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * eml_setop.c
 *
 * Code generation for function 'eml_setop'
 *
 */

/* Include files */
#include <math.h>
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "laplace_iters.h"
#include "eml_setop.h"
#include "laplace_iters_emxutil.h"
#include "error.h"
#include "eml_int_forloop_overflow_check.h"
#include "laplace_iters_data.h"

/* Variable Definitions */
static emlrtRSInfo ob_emlrtRSI = { 224,/* lineNo */
  "eml_setop",                         /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pathName */
};

static emlrtRSInfo pb_emlrtRSI = { 225,/* lineNo */
  "eml_setop",                         /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pathName */
};

static emlrtRSInfo qb_emlrtRSI = { 227,/* lineNo */
  "eml_setop",                         /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pathName */
};

static emlrtRSInfo rb_emlrtRSI = { 228,/* lineNo */
  "eml_setop",                         /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pathName */
};

static emlrtRSInfo sb_emlrtRSI = { 258,/* lineNo */
  "eml_setop",                         /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pathName */
};

static emlrtRSInfo tb_emlrtRSI = { 259,/* lineNo */
  "eml_setop",                         /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pathName */
};

static emlrtRSInfo ub_emlrtRSI = { 261,/* lineNo */
  "eml_setop",                         /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pathName */
};

static emlrtRSInfo vb_emlrtRSI = { 348,/* lineNo */
  "eml_setop",                         /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pathName */
};

static emlrtRSInfo wb_emlrtRSI = { 71, /* lineNo */
  "issorted",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/datafun/issorted.m"/* pathName */
};

static emlrtRSInfo xb_emlrtRSI = { 93, /* lineNo */
  "issorted",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/datafun/issorted.m"/* pathName */
};

static emlrtRSInfo yb_emlrtRSI = { 110,/* lineNo */
  "issorted",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/datafun/issorted.m"/* pathName */
};

static emlrtRSInfo ac_emlrtRSI = { 459,/* lineNo */
  "eml_setop",                         /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pathName */
};

static emlrtRSInfo bc_emlrtRSI = { 31, /* lineNo */
  "safeEq",                            /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/safeEq.m"/* pathName */
};

static emlrtRTEInfo ab_emlrtRTEI = { 134,/* lineNo */
  22,                                  /* colNo */
  "eml_setop",                         /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pName */
};

static emlrtRTEInfo bb_emlrtRTEI = { 434,/* lineNo */
  9,                                   /* colNo */
  "eml_setop",                         /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pName */
};

static emlrtRTEInfo cb_emlrtRTEI = { 398,/* lineNo */
  14,                                  /* colNo */
  "eml_setop",                         /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pName */
};

static emlrtRTEInfo db_emlrtRTEI = { 398,/* lineNo */
  9,                                   /* colNo */
  "eml_setop",                         /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pName */
};

static emlrtRTEInfo ec_emlrtRTEI = { 430,/* lineNo */
  5,                                   /* colNo */
  "eml_setop",                         /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pName */
};

static emlrtRTEInfo fc_emlrtRTEI = { 392,/* lineNo */
  5,                                   /* colNo */
  "eml_setop",                         /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pName */
};

/* Function Declarations */
static real_T skip_to_last_equal_value(int32_T *k, const emxArray_real_T *x);

/* Function Definitions */
static real_T skip_to_last_equal_value(int32_T *k, const emxArray_real_T *x)
{
  real_T xk;
  boolean_T exitg1;
  real_T absxk;
  int32_T exponent;
  boolean_T p;
  xk = x->data[*k - 1];
  exitg1 = false;
  while ((!exitg1) && (*k < x->size[1])) {
    absxk = muDoubleScalarAbs(xk / 2.0);
    if ((!muDoubleScalarIsInf(absxk)) && (!muDoubleScalarIsNaN(absxk))) {
      if (absxk <= 2.2250738585072014E-308) {
        absxk = 4.94065645841247E-324;
      } else {
        frexp(absxk, &exponent);
        absxk = ldexp(1.0, exponent - 53);
      }
    } else {
      absxk = rtNaN;
    }

    if ((muDoubleScalarAbs(xk - x->data[*k]) < absxk) || (muDoubleScalarIsInf
         (x->data[*k]) && muDoubleScalarIsInf(xk) && ((x->data[*k] > 0.0) == (xk
           > 0.0)))) {
      p = true;
    } else {
      p = false;
    }

    if (p) {
      (*k)++;
    } else {
      exitg1 = true;
    }
  }

  return xk;
}

void do_vectors(const emlrtStack *sp, const emxArray_real_T *a, const
                emxArray_real_T *b, emxArray_real_T *c, emxArray_int32_T *ia,
                int32_T ib_size[1])
{
  int32_T na;
  uint32_T unnamed_idx_1;
  int32_T n;
  boolean_T p;
  int32_T iafirst;
  boolean_T exitg1;
  int32_T dim;
  real_T x1;
  real_T v_idx_1;
  int32_T nc;
  int32_T ialast;
  int32_T b_n;
  real_T bk;
  boolean_T exitg2;
  emxArray_int32_T *b_ia;
  int32_T subs[2];
  int32_T exponent;
  int32_T b_exponent;
  boolean_T b0;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  na = a->size[1];
  unnamed_idx_1 = (uint32_T)a->size[1];
  n = c->size[0] * c->size[1];
  c->size[0] = 1;
  c->size[1] = (int32_T)unnamed_idx_1;
  emxEnsureCapacity_real_T(sp, c, n, &ab_emlrtRTEI);
  n = ia->size[0];
  ia->size[0] = a->size[1];
  emxEnsureCapacity_int32_T(sp, ia, n, &ab_emlrtRTEI);
  ib_size[0] = 0;
  st.site = &ob_emlrtRSI;
  p = true;
  if ((a->size[1] != 0) && (a->size[1] != 1)) {
    b_st.site = &wb_emlrtRSI;
    c_st.site = &xb_emlrtRSI;
    iafirst = 1;
    exitg1 = false;
    while ((!exitg1) && (iafirst <= a->size[1] - 1)) {
      x1 = a->data[a->size[0] * (iafirst - 1)];
      v_idx_1 = a->data[a->size[0] * iafirst];
      if ((x1 <= v_idx_1) || muDoubleScalarIsNaN(v_idx_1)) {
        p = true;
      } else {
        p = false;
      }

      if (!p) {
        exitg1 = true;
      } else {
        iafirst++;
      }
    }
  }

  if (!p) {
    st.site = &pb_emlrtRSI;
    error(&st);
  }

  st.site = &qb_emlrtRSI;
  p = true;
  dim = 2;
  if (b->size[0] != 1) {
    dim = 1;
  }

  if (dim <= 1) {
    n = b->size[0];
  } else {
    n = 1;
  }

  if ((b->size[0] != 0) && (n != 1)) {
    b_st.site = &wb_emlrtRSI;
    n = !(dim == 2);
    c_st.site = &xb_emlrtRSI;
    iafirst = 1;
    exitg1 = false;
    while ((!exitg1) && (iafirst <= n)) {
      c_st.site = &yb_emlrtRSI;
      if (dim == 1) {
        b_n = b->size[0] - 1;
      } else {
        b_n = b->size[0];
      }

      d_st.site = &xb_emlrtRSI;
      if ((!(1 > b_n)) && (b_n > 2147483646)) {
        e_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&e_st);
      }

      iafirst = 1;
      exitg2 = false;
      while ((!exitg2) && (iafirst <= b_n)) {
        subs[0] = iafirst;
        subs[1] = 1;
        x1 = b->data[iafirst - 1];
        subs[dim - 1]++;
        v_idx_1 = b->data[subs[0] - 1];
        if ((x1 <= v_idx_1) || muDoubleScalarIsNaN(v_idx_1)) {
          p = true;
        } else {
          p = false;
        }

        if (!p) {
          exitg2 = true;
        } else {
          iafirst++;
        }
      }

      if (!p) {
        exitg1 = true;
      } else {
        iafirst = 2;
      }
    }
  }

  if (!p) {
    st.site = &rb_emlrtRSI;
    b_error(&st);
  }

  nc = 0;
  dim = 0;
  iafirst = 0;
  ialast = 1;
  n = 1;
  while ((ialast <= na) && (n <= b->size[0])) {
    b_n = ialast;
    st.site = &sb_emlrtRSI;
    v_idx_1 = skip_to_last_equal_value(&b_n, a);
    ialast = b_n;
    st.site = &tb_emlrtRSI;
    bk = b->data[n - 1];
    exitg1 = false;
    while ((!exitg1) && (n < b->size[0])) {
      b_st.site = &ac_emlrtRSI;
      c_st.site = &bc_emlrtRSI;
      x1 = muDoubleScalarAbs(bk / 2.0);
      if ((!muDoubleScalarIsInf(x1)) && (!muDoubleScalarIsNaN(x1))) {
        if (x1 <= 2.2250738585072014E-308) {
          x1 = 4.94065645841247E-324;
        } else {
          frexp(x1, &exponent);
          x1 = ldexp(1.0, exponent - 53);
        }
      } else {
        x1 = rtNaN;
      }

      if ((muDoubleScalarAbs(bk - b->data[n]) < x1) || (muDoubleScalarIsInf
           (b->data[n]) && muDoubleScalarIsInf(bk) && ((b->data[n] > 0.0) == (bk
             > 0.0)))) {
        p = true;
      } else {
        p = false;
      }

      if (p) {
        n++;
      } else {
        exitg1 = true;
      }
    }

    st.site = &ub_emlrtRSI;
    b_st.site = &bc_emlrtRSI;
    x1 = muDoubleScalarAbs(bk / 2.0);
    if ((!muDoubleScalarIsInf(x1)) && (!muDoubleScalarIsNaN(x1))) {
      if (x1 <= 2.2250738585072014E-308) {
        x1 = 4.94065645841247E-324;
      } else {
        frexp(x1, &b_exponent);
        x1 = ldexp(1.0, b_exponent - 53);
      }
    } else {
      x1 = rtNaN;
    }

    if ((muDoubleScalarAbs(bk - v_idx_1) < x1) || (muDoubleScalarIsInf(v_idx_1) &&
         muDoubleScalarIsInf(bk) && ((v_idx_1 > 0.0) == (bk > 0.0)))) {
      p = true;
    } else {
      p = false;
    }

    if (p) {
      ialast = b_n + 1;
      iafirst = b_n;
      n++;
    } else {
      if (muDoubleScalarIsNaN(bk)) {
        b0 = !muDoubleScalarIsNaN(v_idx_1);
      } else {
        b0 = ((!muDoubleScalarIsNaN(v_idx_1)) && (v_idx_1 < bk));
      }

      if (b0) {
        nc++;
        dim++;
        c->data[nc - 1] = v_idx_1;
        ia->data[dim - 1] = iafirst + 1;
        ialast = b_n + 1;
        iafirst = b_n;
      } else {
        n++;
      }
    }
  }

  while (ialast <= na) {
    iafirst = ialast;
    st.site = &vb_emlrtRSI;
    v_idx_1 = skip_to_last_equal_value(&iafirst, a);
    nc++;
    dim++;
    c->data[nc - 1] = v_idx_1;
    ia->data[dim - 1] = ialast;
    ialast = iafirst + 1;
  }

  if (a->size[1] > 0) {
    if (!(dim <= a->size[1])) {
      emlrtErrorWithMessageIdR2018a(sp, &fc_emlrtRTEI,
        "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
    }

    if (1 > dim) {
      iafirst = 0;
    } else {
      iafirst = dim;
    }

    emxInit_int32_T(sp, &b_ia, 1, &cb_emlrtRTEI, true);
    n = b_ia->size[0];
    b_ia->size[0] = iafirst;
    emxEnsureCapacity_int32_T(sp, b_ia, n, &cb_emlrtRTEI);
    for (n = 0; n < iafirst; n++) {
      b_ia->data[n] = ia->data[n];
    }

    n = ia->size[0];
    ia->size[0] = b_ia->size[0];
    emxEnsureCapacity_int32_T(sp, ia, n, &db_emlrtRTEI);
    iafirst = b_ia->size[0];
    for (n = 0; n < iafirst; n++) {
      ia->data[n] = b_ia->data[n];
    }

    emxFree_int32_T(sp, &b_ia);
    if (!(nc <= a->size[1])) {
      emlrtErrorWithMessageIdR2018a(sp, &ec_emlrtRTEI,
        "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
    }

    n = c->size[0] * c->size[1];
    if (1 > nc) {
      c->size[1] = 0;
    } else {
      c->size[1] = nc;
    }

    emxEnsureCapacity_real_T(sp, c, n, &bb_emlrtRTEI);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (eml_setop.c) */
