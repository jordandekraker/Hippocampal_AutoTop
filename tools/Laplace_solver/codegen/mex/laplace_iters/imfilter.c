/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * imfilter.c
 *
 * Code generation for function 'imfilter'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "laplace_iters.h"
#include "imfilter.h"
#include "laplace_iters_emxutil.h"
#include "libmwimfilter.h"

/* Variable Definitions */
static emlrtRSInfo cc_emlrtRSI = { 106,/* lineNo */
  "imfilter",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/imfilter.m"/* pathName */
};

static emlrtRSInfo dc_emlrtRSI = { 110,/* lineNo */
  "imfilter",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/imfilter.m"/* pathName */
};

static emlrtRSInfo ec_emlrtRSI = { 769,/* lineNo */
  "imfilter",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/imfilter.m"/* pathName */
};

static emlrtRSInfo fc_emlrtRSI = { 20, /* lineNo */
  "padarray",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pathName */
};

static emlrtRSInfo gc_emlrtRSI = { 64, /* lineNo */
  "padarray",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pathName */
};

static emlrtRSInfo hc_emlrtRSI = { 80, /* lineNo */
  "padarray",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pathName */
};

static emlrtRSInfo ic_emlrtRSI = { 70, /* lineNo */
  "validateattributes",                /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/lang/validateattributes.m"/* pathName */
};

static emlrtRSInfo jc_emlrtRSI = { 22, /* lineNo */
  "repmat",                            /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/elmat/repmat.m"/* pathName */
};

static emlrtRSInfo kc_emlrtRSI = { 736,/* lineNo */
  "padarray",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pathName */
};

static emlrtRSInfo lc_emlrtRSI = { 843,/* lineNo */
  "imfilter",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/imfilter.m"/* pathName */
};

static emlrtRSInfo mc_emlrtRSI = { 917,/* lineNo */
  "imfilter",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/imfilter.m"/* pathName */
};

static emlrtRTEInfo eb_emlrtRTEI = { 736,/* lineNo */
  12,                                  /* colNo */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pName */
};

static emlrtRTEInfo fb_emlrtRTEI = { 25,/* lineNo */
  9,                                   /* colNo */
  "colon",                             /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/colon.m"/* pName */
};

static emlrtRTEInfo gb_emlrtRTEI = { 845,/* lineNo */
  9,                                   /* colNo */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pName */
};

static emlrtRTEInfo hb_emlrtRTEI = { 846,/* lineNo */
  14,                                  /* colNo */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pName */
};

static emlrtRTEInfo ib_emlrtRTEI = { 769,/* lineNo */
  5,                                   /* colNo */
  "imfilter",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/imfilter.m"/* pName */
};

static emlrtRTEInfo jb_emlrtRTEI = { 846,/* lineNo */
  36,                                  /* colNo */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pName */
};

static emlrtRTEInfo kb_emlrtRTEI = { 769,/* lineNo */
  9,                                   /* colNo */
  "imfilter",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/imfilter.m"/* pName */
};

static emlrtRTEInfo lb_emlrtRTEI = { 80,/* lineNo */
  5,                                   /* colNo */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pName */
};

static emlrtRTEInfo mb_emlrtRTEI = { 839,/* lineNo */
  9,                                   /* colNo */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pName */
};

static emlrtRTEInfo nb_emlrtRTEI = { 762,/* lineNo */
  14,                                  /* colNo */
  "imfilter",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/imfilter.m"/* pName */
};

static emlrtRTEInfo ob_emlrtRTEI = { 845,/* lineNo */
  30,                                  /* colNo */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pName */
};

static emlrtRTEInfo wb_emlrtRTEI = { 917,/* lineNo */
  11,                                  /* colNo */
  "imfilter",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/imfilter.m"/* pName */
};

static emlrtRTEInfo xb_emlrtRTEI = { 59,/* lineNo */
  9,                                   /* colNo */
  "imfilter",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/imfilter.m"/* pName */
};

static emlrtRTEInfo hc_emlrtRTEI = { 61,/* lineNo */
  15,                                  /* colNo */
  "assertValidSizeArg",                /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/assertValidSizeArg.m"/* pName */
};

static emlrtRTEInfo ic_emlrtRTEI = { 46,/* lineNo */
  19,                                  /* colNo */
  "assertValidSizeArg",                /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/assertValidSizeArg.m"/* pName */
};

static emlrtDCInfo l_emlrtDCI = { 827, /* lineNo */
  33,                                  /* colNo */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo p_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  846,                                 /* lineNo */
  16,                                  /* colNo */
  "",                                  /* aName */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo c_emlrtECI = { -1,  /* nDims */
  846,                                 /* lineNo */
  9,                                   /* colNo */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m"/* pName */
};

static emlrtDCInfo m_emlrtDCI = { 83,  /* lineNo */
  56,                                  /* colNo */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo q_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  93,                                  /* lineNo */
  36,                                  /* colNo */
  "",                                  /* aName */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo r_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  93,                                  /* lineNo */
  25,                                  /* colNo */
  "",                                  /* aName */
  "padarray",                          /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/images/images/eml/padarray.m",/* pName */
  0                                    /* checkKind */
};

/* Function Declarations */
static void padImage(const emlrtStack *sp, const emxArray_real_T *a_tmp, const
                     real_T pad[3], emxArray_real_T *a);

/* Function Definitions */
static void padImage(const emlrtStack *sp, const emxArray_real_T *a_tmp, const
                     real_T pad[3], emxArray_real_T *a)
{
  int32_T i1;
  real_T sizeA[3];
  real_T varargin_1[3];
  uint32_T b_sizeA[3];
  int32_T k;
  boolean_T guard1 = false;
  uint32_T ex;
  int32_T exitg2;
  emxArray_int32_T *idxA;
  emxArray_real_T *y;
  boolean_T exitg1;
  real_T n;
  emxArray_uint32_T *idxDir;
  emxArray_int32_T *r1;
  int32_T i2;
  emxArray_int32_T *b_idxDir;
  int32_T iv0[1];
  int32_T j;
  int32_T i3;
  int32_T i;
  int32_T i4;
  int32_T i5;
  int32_T i6;
  int32_T i7;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &ec_emlrtRSI;
  b_st.site = &fc_emlrtRSI;
  c_st.site = &ic_emlrtRSI;
  c_st.site = &ic_emlrtRSI;
  c_st.site = &ic_emlrtRSI;
  if ((a_tmp->size[0] == 0) || (a_tmp->size[1] == 0) || (a_tmp->size[2] == 0)) {
    for (i1 = 0; i1 < 3; i1++) {
      sizeA[i1] = (real_T)a_tmp->size[i1] + 2.0 * pad[i1];
    }

    b_st.site = &gc_emlrtRSI;
    varargin_1[0] = sizeA[0];
    varargin_1[1] = sizeA[1];
    varargin_1[2] = sizeA[2];
    c_st.site = &jc_emlrtRSI;
    k = 0;
    guard1 = false;
    do {
      exitg2 = 0;
      if (k < 3) {
        if ((varargin_1[k] != varargin_1[k]) || muDoubleScalarIsInf(varargin_1[k]))
        {
          guard1 = true;
          exitg2 = 1;
        } else {
          k++;
          guard1 = false;
        }
      } else {
        k = 0;
        exitg2 = 2;
      }
    } while (exitg2 == 0);

    if (exitg2 == 1) {
    } else {
      exitg1 = false;
      while ((!exitg1) && (k < 3)) {
        if (varargin_1[k] > 2.147483647E+9) {
          guard1 = true;
          exitg1 = true;
        } else {
          k++;
        }
      }
    }

    if (guard1) {
      emlrtErrorWithMessageIdR2018a(&c_st, &ic_emlrtRTEI,
        "Coder:toolbox:eml_assert_valid_size_arg_invalidSizeVector",
        "Coder:toolbox:eml_assert_valid_size_arg_invalidSizeVector", 4, 12,
        MIN_int32_T, 12, MAX_int32_T);
    }

    n = 1.0;
    for (k = 0; k < 3; k++) {
      n *= varargin_1[k];
    }

    if (!(n <= 2.147483647E+9)) {
      emlrtErrorWithMessageIdR2018a(&c_st, &hc_emlrtRTEI,
        "Coder:MATLAB:pmaxsize", "Coder:MATLAB:pmaxsize", 0);
    }

    i1 = a->size[0] * a->size[1] * a->size[2];
    a->size[0] = (int32_T)sizeA[0];
    a->size[1] = (int32_T)sizeA[1];
    a->size[2] = (int32_T)sizeA[2];
    emxEnsureCapacity_real_T1(&b_st, a, i1, &ib_emlrtRTEI);
    k = (int32_T)sizeA[0] * (int32_T)sizeA[1] * (int32_T)sizeA[2];
    for (i1 = 0; i1 < k; i1++) {
      a->data[i1] = 0.0;
    }
  } else {
    for (i1 = 0; i1 < 3; i1++) {
      sizeA[i1] = a_tmp->size[i1];
    }

    b_st.site = &hc_emlrtRSI;
    c_st.site = &kc_emlrtRSI;
    b_sizeA[0] = (uint32_T)sizeA[0];
    b_sizeA[1] = (uint32_T)sizeA[1];
    b_sizeA[2] = (uint32_T)sizeA[2];
    for (i1 = 0; i1 < 3; i1++) {
      varargin_1[i1] = 2.0 + (real_T)b_sizeA[i1];
    }

    ex = (uint32_T)varargin_1[0];
    for (k = 1; k + 1 < 4; k++) {
      if (ex < (uint32_T)varargin_1[k]) {
        ex = (uint32_T)varargin_1[k];
      }
    }

    emxInit_int32_T1(&c_st, &idxA, 2, &lb_emlrtRTEI, true);
    emxInit_real_T(&c_st, &y, 2, &ob_emlrtRTEI, true);
    if ((real_T)ex != (int32_T)ex) {
      emlrtIntegerCheckR2012b(ex, &l_emlrtDCI, &c_st);
    }

    i1 = idxA->size[0] * idxA->size[1];
    idxA->size[0] = (int32_T)ex;
    idxA->size[1] = 3;
    emxEnsureCapacity_int32_T1(&c_st, idxA, i1, &eb_emlrtRTEI);
    i1 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = (int32_T)((real_T)(uint32_T)sizeA[0] - 1.0) + 1;
    emxEnsureCapacity_real_T(&c_st, y, i1, &fb_emlrtRTEI);
    k = (int32_T)((real_T)(uint32_T)sizeA[0] - 1.0);
    for (i1 = 0; i1 <= k; i1++) {
      y->data[y->size[0] * i1] = 1.0 + (real_T)i1;
    }

    emxInit_uint32_T(&c_st, &idxDir, 2, &mb_emlrtRTEI, true);
    i1 = idxDir->size[0] * idxDir->size[1];
    idxDir->size[0] = 1;
    idxDir->size[1] = 2 + y->size[1];
    emxEnsureCapacity_uint32_T(&c_st, idxDir, i1, &gb_emlrtRTEI);
    idxDir->data[0] = 1U;
    k = y->size[1];
    for (i1 = 0; i1 < k; i1++) {
      idxDir->data[idxDir->size[0] * (i1 + 1)] = (uint32_T)muDoubleScalarRound
        (y->data[y->size[0] * i1]);
    }

    emxInit_int32_T(&c_st, &r1, 1, &nb_emlrtRTEI, true);
    idxDir->data[idxDir->size[0] * (1 + y->size[1])] = (uint32_T)sizeA[0];
    i1 = (int32_T)ex;
    i2 = idxDir->size[1];
    if (!((i2 >= 1) && (i2 <= i1))) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &p_emlrtBCI, &c_st);
    }

    k = idxDir->size[1];
    i1 = r1->size[0];
    r1->size[0] = k;
    emxEnsureCapacity_int32_T(&c_st, r1, i1, &hb_emlrtRTEI);
    for (i1 = 0; i1 < k; i1++) {
      r1->data[i1] = i1;
    }

    emxInit_int32_T1(&c_st, &b_idxDir, 2, &jb_emlrtRTEI, true);
    iv0[0] = r1->size[0];
    emlrtSubAssignSizeCheckR2012b(&iv0[0], 1, &(*(int32_T (*)[2])idxDir->size)[0],
      2, &c_emlrtECI, &c_st);
    i1 = b_idxDir->size[0] * b_idxDir->size[1];
    b_idxDir->size[0] = 1;
    b_idxDir->size[1] = idxDir->size[1];
    emxEnsureCapacity_int32_T1(&c_st, b_idxDir, i1, &jb_emlrtRTEI);
    k = idxDir->size[1];
    for (i1 = 0; i1 < k; i1++) {
      b_idxDir->data[b_idxDir->size[0] * i1] = (int32_T)idxDir->data
        [idxDir->size[0] * i1];
    }

    k = r1->size[0];
    for (i1 = 0; i1 < k; i1++) {
      idxA->data[r1->data[i1]] = b_idxDir->data[i1];
    }

    i1 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = (int32_T)((real_T)(uint32_T)sizeA[1] - 1.0) + 1;
    emxEnsureCapacity_real_T(&c_st, y, i1, &fb_emlrtRTEI);
    k = (int32_T)((real_T)(uint32_T)sizeA[1] - 1.0);
    for (i1 = 0; i1 <= k; i1++) {
      y->data[y->size[0] * i1] = 1.0 + (real_T)i1;
    }

    i1 = idxDir->size[0] * idxDir->size[1];
    idxDir->size[0] = 1;
    idxDir->size[1] = 2 + y->size[1];
    emxEnsureCapacity_uint32_T(&c_st, idxDir, i1, &gb_emlrtRTEI);
    idxDir->data[0] = 1U;
    k = y->size[1];
    for (i1 = 0; i1 < k; i1++) {
      idxDir->data[idxDir->size[0] * (i1 + 1)] = (uint32_T)muDoubleScalarRound
        (y->data[y->size[0] * i1]);
    }

    idxDir->data[idxDir->size[0] * (1 + y->size[1])] = (uint32_T)sizeA[1];
    i1 = idxA->size[0];
    i2 = idxDir->size[1];
    if (!((i2 >= 1) && (i2 <= i1))) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &p_emlrtBCI, &c_st);
    }

    k = idxDir->size[1];
    i1 = r1->size[0];
    r1->size[0] = k;
    emxEnsureCapacity_int32_T(&c_st, r1, i1, &hb_emlrtRTEI);
    for (i1 = 0; i1 < k; i1++) {
      r1->data[i1] = i1;
    }

    iv0[0] = r1->size[0];
    emlrtSubAssignSizeCheckR2012b(&iv0[0], 1, &(*(int32_T (*)[2])idxDir->size)[0],
      2, &c_emlrtECI, &c_st);
    i1 = b_idxDir->size[0] * b_idxDir->size[1];
    b_idxDir->size[0] = 1;
    b_idxDir->size[1] = idxDir->size[1];
    emxEnsureCapacity_int32_T1(&c_st, b_idxDir, i1, &jb_emlrtRTEI);
    k = idxDir->size[1];
    for (i1 = 0; i1 < k; i1++) {
      b_idxDir->data[b_idxDir->size[0] * i1] = (int32_T)idxDir->data
        [idxDir->size[0] * i1];
    }

    k = r1->size[0];
    for (i1 = 0; i1 < k; i1++) {
      idxA->data[r1->data[i1] + idxA->size[0]] = b_idxDir->data[i1];
    }

    i1 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = (int32_T)((real_T)(uint32_T)sizeA[2] - 1.0) + 1;
    emxEnsureCapacity_real_T(&c_st, y, i1, &fb_emlrtRTEI);
    k = (int32_T)((real_T)(uint32_T)sizeA[2] - 1.0);
    for (i1 = 0; i1 <= k; i1++) {
      y->data[y->size[0] * i1] = 1.0 + (real_T)i1;
    }

    i1 = idxDir->size[0] * idxDir->size[1];
    idxDir->size[0] = 1;
    idxDir->size[1] = 2 + y->size[1];
    emxEnsureCapacity_uint32_T(&c_st, idxDir, i1, &gb_emlrtRTEI);
    idxDir->data[0] = 1U;
    k = y->size[1];
    for (i1 = 0; i1 < k; i1++) {
      idxDir->data[idxDir->size[0] * (i1 + 1)] = (uint32_T)muDoubleScalarRound
        (y->data[y->size[0] * i1]);
    }

    idxDir->data[idxDir->size[0] * (1 + y->size[1])] = (uint32_T)sizeA[2];
    i1 = idxA->size[0];
    i2 = idxDir->size[1];
    if (!((i2 >= 1) && (i2 <= i1))) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &p_emlrtBCI, &c_st);
    }

    k = idxDir->size[1];
    i1 = r1->size[0];
    r1->size[0] = k;
    emxEnsureCapacity_int32_T(&c_st, r1, i1, &hb_emlrtRTEI);
    emxFree_real_T(&c_st, &y);
    for (i1 = 0; i1 < k; i1++) {
      r1->data[i1] = i1;
    }

    iv0[0] = r1->size[0];
    emlrtSubAssignSizeCheckR2012b(&iv0[0], 1, &(*(int32_T (*)[2])idxDir->size)[0],
      2, &c_emlrtECI, &c_st);
    i1 = b_idxDir->size[0] * b_idxDir->size[1];
    b_idxDir->size[0] = 1;
    b_idxDir->size[1] = idxDir->size[1];
    emxEnsureCapacity_int32_T1(&c_st, b_idxDir, i1, &jb_emlrtRTEI);
    k = idxDir->size[1];
    for (i1 = 0; i1 < k; i1++) {
      b_idxDir->data[b_idxDir->size[0] * i1] = (int32_T)idxDir->data
        [idxDir->size[0] * i1];
    }

    emxFree_uint32_T(&c_st, &idxDir);
    k = r1->size[0];
    for (i1 = 0; i1 < k; i1++) {
      idxA->data[r1->data[i1] + (idxA->size[0] << 1)] = b_idxDir->data[i1];
    }

    emxFree_int32_T(&c_st, &b_idxDir);
    emxFree_int32_T(&c_st, &r1);
    for (i1 = 0; i1 < 3; i1++) {
      n = (real_T)a_tmp->size[i1] + 2.0 * pad[i1];
      if (n != (int32_T)muDoubleScalarFloor(n)) {
        emlrtIntegerCheckR2012b(n, &m_emlrtDCI, &st);
      }

      sizeA[i1] = n;
    }

    i1 = a->size[0] * a->size[1] * a->size[2];
    a->size[0] = (int32_T)sizeA[0];
    a->size[1] = (int32_T)sizeA[1];
    a->size[2] = (int32_T)sizeA[2];
    emxEnsureCapacity_real_T1(&st, a, i1, &kb_emlrtRTEI);
    i1 = a->size[2];
    for (k = 1; k - 1 < i1; k++) {
      i2 = a->size[1];
      for (j = 1; j - 1 < i2; j++) {
        i3 = a->size[0];
        for (i = 1; i - 1 < i3; i++) {
          i4 = a_tmp->size[0];
          i5 = idxA->size[0];
          if (!((i >= 1) && (i <= i5))) {
            emlrtDynamicBoundsCheckR2012b(i, 1, i5, &q_emlrtBCI, &st);
          }

          i5 = idxA->data[i - 1];
          if (!((i5 >= 1) && (i5 <= i4))) {
            emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &q_emlrtBCI, &st);
          }

          i4 = a_tmp->size[1];
          i6 = idxA->size[0];
          if (!((j >= 1) && (j <= i6))) {
            emlrtDynamicBoundsCheckR2012b(j, 1, i6, &q_emlrtBCI, &st);
          }

          i6 = idxA->data[(j + idxA->size[0]) - 1];
          if (!((i6 >= 1) && (i6 <= i4))) {
            emlrtDynamicBoundsCheckR2012b(i6, 1, i4, &q_emlrtBCI, &st);
          }

          i4 = a_tmp->size[2];
          i7 = idxA->size[0];
          if (!((k >= 1) && (k <= i7))) {
            emlrtDynamicBoundsCheckR2012b(k, 1, i7, &q_emlrtBCI, &st);
          }

          i7 = idxA->data[(k + (idxA->size[0] << 1)) - 1];
          if (!((i7 >= 1) && (i7 <= i4))) {
            emlrtDynamicBoundsCheckR2012b(i7, 1, i4, &q_emlrtBCI, &st);
          }

          i4 = a->size[0];
          if (!((i >= 1) && (i <= i4))) {
            emlrtDynamicBoundsCheckR2012b(i, 1, i4, &r_emlrtBCI, &st);
          }

          i4 = a->size[1];
          if (!((j >= 1) && (j <= i4))) {
            emlrtDynamicBoundsCheckR2012b(j, 1, i4, &r_emlrtBCI, &st);
          }

          i4 = a->size[2];
          if (!((k >= 1) && (k <= i4))) {
            emlrtDynamicBoundsCheckR2012b(k, 1, i4, &r_emlrtBCI, &st);
          }

          a->data[((i + a->size[0] * (j - 1)) + a->size[0] * a->size[1] * (k - 1))
            - 1] = a_tmp->data[((i5 + a_tmp->size[0] * (i6 - 1)) + a_tmp->size[0]
                                * a_tmp->size[1] * (i7 - 1)) - 1];
        }
      }
    }

    emxFree_int32_T(&st, &idxA);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

void imfilter(const emlrtStack *sp, emxArray_real_T *varargin_1, const real_T
              varargin_2[27])
{
  real_T outSizeT[3];
  real_T startT[3];
  emxArray_real_T *a;
  int32_T trueCount;
  int32_T i;
  int32_T partialTrueCount;
  int8_T tmp_data[27];
  real_T nonzero_h_data[27];
  boolean_T connb[27];
  real_T padSizeT[3];
  real_T connDimsT[3];
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  outSizeT[0] = varargin_1->size[0];
  startT[0] = 1.0;
  outSizeT[1] = varargin_1->size[1];
  startT[1] = 1.0;
  outSizeT[2] = varargin_1->size[2];
  startT[2] = 1.0;
  if (!((varargin_1->size[0] == 0) || (varargin_1->size[1] == 0) ||
        (varargin_1->size[2] == 0))) {
    emxInit_real_T2(sp, &a, 3, &xb_emlrtRTEI, true);
    st.site = &cc_emlrtRSI;
    padImage(&st, varargin_1, startT, a);
    st.site = &dc_emlrtRSI;
    trueCount = 0;
    for (i = 0; i < 27; i++) {
      if (varargin_2[i] != 0.0) {
        trueCount++;
      }
    }

    partialTrueCount = 0;
    for (i = 0; i < 27; i++) {
      if (varargin_2[i] != 0.0) {
        tmp_data[partialTrueCount] = (int8_T)(i + 1);
        partialTrueCount++;
      }
    }

    b_st.site = &lc_emlrtRSI;
    for (i = 0; i < trueCount; i++) {
      nonzero_h_data[i] = varargin_2[tmp_data[i] - 1];
    }

    for (i = 0; i < 27; i++) {
      connb[i] = (varargin_2[i] != 0.0);
    }

    c_st.site = &mc_emlrtRSI;
    i = varargin_1->size[0] * varargin_1->size[1] * varargin_1->size[2];
    varargin_1->size[0] = (int32_T)outSizeT[0];
    varargin_1->size[1] = (int32_T)outSizeT[1];
    varargin_1->size[2] = (int32_T)outSizeT[2];
    emxEnsureCapacity_real_T1(&c_st, varargin_1, i, &wb_emlrtRTEI);
    for (i = 0; i < 3; i++) {
      padSizeT[i] = a->size[i];
    }

    for (i = 0; i < 3; i++) {
      connDimsT[i] = 3.0;
    }

    imfilter_real64(&a->data[0], &varargin_1->data[0], 3.0, outSizeT, 3.0,
                    padSizeT, &nonzero_h_data[0], (real_T)trueCount, connb, 3.0,
                    connDimsT, startT, 3.0, true, true);
    emxFree_real_T(sp, &a);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (imfilter.c) */
