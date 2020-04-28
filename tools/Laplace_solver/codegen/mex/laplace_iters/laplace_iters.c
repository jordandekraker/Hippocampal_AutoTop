/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * laplace_iters.c
 *
 * Code generation for function 'laplace_iters'
 *
 */

/* Include files */
#include <string.h>
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "laplace_iters.h"
#include "laplace_iters_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "indexShapeCheck.h"
#include "imfilter.h"
#include "eml_setop.h"
#include "sort1.h"
#include "laplace_iters_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 3,     /* lineNo */
  "laplace_iters",                     /* fcnName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pathName */
};

static emlrtRSInfo b_emlrtRSI = { 25,  /* lineNo */
  "laplace_iters",                     /* fcnName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pathName */
};

static emlrtRSInfo c_emlrtRSI = { 30,  /* lineNo */
  "laplace_iters",                     /* fcnName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pathName */
};

static emlrtRSInfo d_emlrtRSI = { 37,  /* lineNo */
  "laplace_iters",                     /* fcnName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pathName */
};

static emlrtRSInfo e_emlrtRSI = { 41,  /* lineNo */
  "laplace_iters",                     /* fcnName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pathName */
};

static emlrtRSInfo f_emlrtRSI = { 47,  /* lineNo */
  "laplace_iters",                     /* fcnName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pathName */
};

static emlrtRSInfo g_emlrtRSI = { 53,  /* lineNo */
  "laplace_iters",                     /* fcnName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pathName */
};

static emlrtRSInfo h_emlrtRSI = { 54,  /* lineNo */
  "laplace_iters",                     /* fcnName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pathName */
};

static emlrtRSInfo i_emlrtRSI = { 40,  /* lineNo */
  "mpower",                            /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/mpower.m"/* pathName */
};

static emlrtRSInfo j_emlrtRSI = { 49,  /* lineNo */
  "power",                             /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/power.m"/* pathName */
};

static emlrtRSInfo k_emlrtRSI = { 28,  /* lineNo */
  "sort",                              /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/datafun/sort.m"/* pathName */
};

static emlrtRSInfo mb_emlrtRSI = { 19, /* lineNo */
  "setdiff",                           /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/setdiff.m"/* pathName */
};

static emlrtRSInfo nb_emlrtRSI = { 70, /* lineNo */
  "eml_setop",                         /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/private/eml_setop.m"/* pathName */
};

static emlrtRSInfo qc_emlrtRSI = { 16, /* lineNo */
  "abs",                               /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/elfun/abs.m"/* pathName */
};

static emlrtRSInfo rc_emlrtRSI = { 74, /* lineNo */
  "applyScalarFunction",               /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/applyScalarFunction.m"/* pathName */
};

static emlrtRSInfo sc_emlrtRSI = { 7,  /* lineNo */
  "nansum",                            /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/stats/eml/nansum.m"/* pathName */
};

static emlrtRSInfo tc_emlrtRSI = { 74, /* lineNo */
  "nan_sum_or_mean",                   /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/stats/eml/private/nan_sum_or_mean.m"/* pathName */
};

static emlrtRSInfo uc_emlrtRSI = { 13, /* lineNo */
  "max",                               /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/datafun/max.m"/* pathName */
};

static emlrtRSInfo vc_emlrtRSI = { 19, /* lineNo */
  "minOrMax",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/minOrMax.m"/* pathName */
};

static emlrtRSInfo wc_emlrtRSI = { 40, /* lineNo */
  "minOrMax",                          /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/minOrMax.m"/* pathName */
};

static emlrtRSInfo xc_emlrtRSI = { 114,/* lineNo */
  "unaryMinOrMax",                     /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo yc_emlrtRSI = { 852,/* lineNo */
  "unaryMinOrMax",                     /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo ad_emlrtRSI = { 844,/* lineNo */
  "unaryMinOrMax",                     /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo bd_emlrtRSI = { 894,/* lineNo */
  "unaryMinOrMax",                     /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo cd_emlrtRSI = { 910,/* lineNo */
  "unaryMinOrMax",                     /* fcnName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/unaryMinOrMax.m"/* pathName */
};

static emlrtRTEInfo emlrtRTEI = { 18,  /* lineNo */
  1,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo b_emlrtRTEI = { 21,/* lineNo */
  1,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo c_emlrtRTEI = { 22,/* lineNo */
  5,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo d_emlrtRTEI = { 23,/* lineNo */
  5,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo e_emlrtRTEI = { 24,/* lineNo */
  5,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo f_emlrtRTEI = { 25,/* lineNo */
  21,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo g_emlrtRTEI = { 25,/* lineNo */
  1,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo h_emlrtRTEI = { 26,/* lineNo */
  5,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo i_emlrtRTEI = { 27,/* lineNo */
  1,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo j_emlrtRTEI = { 28,/* lineNo */
  1,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo k_emlrtRTEI = { 29,/* lineNo */
  21,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo l_emlrtRTEI = { 37,/* lineNo */
  5,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo m_emlrtRTEI = { 53,/* lineNo */
  1,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo n_emlrtRTEI = { 1, /* lineNo */
  30,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo o_emlrtRTEI = { 41,/* lineNo */
  5,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo p_emlrtRTEI = { 42,/* lineNo */
  11,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo q_emlrtRTEI = { 43,/* lineNo */
  11,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo r_emlrtRTEI = { 44,/* lineNo */
  11,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo s_emlrtRTEI = { 47,/* lineNo */
  37,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo t_emlrtRTEI = { 16,/* lineNo */
  5,                                   /* colNo */
  "abs",                               /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/elfun/abs.m"/* pName */
};

static emlrtRTEInfo u_emlrtRTEI = { 48,/* lineNo */
  5,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo v_emlrtRTEI = { 25,/* lineNo */
  26,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo w_emlrtRTEI = { 25,/* lineNo */
  7,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo x_emlrtRTEI = { 47,/* lineNo */
  33,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtECInfo emlrtECI = { -1,    /* nDims */
  22,                                  /* lineNo */
  1,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtECInfo b_emlrtECI = { -1,  /* nDims */
  47,                                  /* lineNo */
  37,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m"/* pName */
};

static emlrtRTEInfo yb_emlrtRTEI = { 13,/* lineNo */
  15,                                  /* colNo */
  "rdivide",                           /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/lib/matlab/ops/rdivide.m"/* pName */
};

static emlrtRTEInfo ac_emlrtRTEI = { 30,/* lineNo */
  27,                                  /* colNo */
  "nan_sum_or_mean",                   /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/stats/eml/private/nan_sum_or_mean.m"/* pName */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  75,                                  /* lineNo */
  21,                                  /* colNo */
  "",                                  /* aName */
  "nan_sum_or_mean",                   /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/stats/eml/private/nan_sum_or_mean.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo bc_emlrtRTEI = { 22,/* lineNo */
  27,                                  /* colNo */
  "unaryMinOrMax",                     /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/unaryMinOrMax.m"/* pName */
};

static emlrtRTEInfo cc_emlrtRTEI = { 77,/* lineNo */
  27,                                  /* colNo */
  "unaryMinOrMax",                     /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/eml/eml/+coder/+internal/unaryMinOrMax.m"/* pName */
};

static emlrtDCInfo emlrtDCI = { 27,    /* lineNo */
  23,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 27,  /* lineNo */
  23,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo c_emlrtDCI = { 21,  /* lineNo */
  11,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo d_emlrtDCI = { 21,  /* lineNo */
  11,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo e_emlrtDCI = { 22,  /* lineNo */
  5,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  22,                                  /* lineNo */
  5,                                   /* colNo */
  "vel",                               /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo f_emlrtDCI = { 23,  /* lineNo */
  5,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  23,                                  /* lineNo */
  5,                                   /* colNo */
  "vel",                               /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo g_emlrtDCI = { 24,  /* lineNo */
  5,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  24,                                  /* lineNo */
  5,                                   /* colNo */
  "vel",                               /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo h_emlrtDCI = { 26,  /* lineNo */
  5,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo e_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  26,                                  /* lineNo */
  5,                                   /* colNo */
  "vel",                               /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo i_emlrtDCI = { 27,  /* lineNo */
  1,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo j_emlrtDCI = { 27,  /* lineNo */
  1,                                   /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo k_emlrtDCI = { 28,  /* lineNo */
  29,                                  /* colNo */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo f_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  29,                                  /* lineNo */
  21,                                  /* colNo */
  "insulate_correction",               /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo g_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  42,                                  /* lineNo */
  11,                                  /* colNo */
  "velup",                             /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo h_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  43,                                  /* lineNo */
  11,                                  /* colNo */
  "velup",                             /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo i_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  44,                                  /* lineNo */
  11,                                  /* colNo */
  "velup",                             /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo j_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  47,                                  /* lineNo */
  41,                                  /* colNo */
  "vel",                               /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo k_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  47,                                  /* lineNo */
  51,                                  /* colNo */
  "velup",                             /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo l_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  76,                                  /* lineNo */
  21,                                  /* colNo */
  "",                                  /* aName */
  "nan_sum_or_mean",                   /* fName */
  "/usr/local/MATLAB/R2018a/toolbox/stats/eml/private/nan_sum_or_mean.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo m_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  47,                                  /* lineNo */
  5,                                   /* colNo */
  "iter_change",                       /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo n_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  49,                                  /* lineNo */
  8,                                   /* colNo */
  "iter_change",                       /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo o_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  54,                                  /* lineNo */
  1,                                   /* colNo */
  "vel",                               /* aName */
  "laplace_iters",                     /* fName */
  "/home/jordandekraker/graham/scratch/Hippocampal_AutoTop/tools/Laplace_solver/laplace_iters.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void laplace_iters(const emlrtStack *sp, const emxArray_real_T *fg, const
                   emxArray_real_T *source, const emxArray_real_T *sink, const
                   emxArray_real_T *init, real_T maxiters, const real_T sz[3],
                   emxArray_real_T *LP, emxArray_real_T *iter_change)
{
  real_T hl[27];
  int32_T i0;
  int32_T k;
  real_T y;
  emxArray_real_T *elems;
  int32_T loop_ub;
  emxArray_int32_T *ia;
  int32_T idx;
  int32_T b_LP;
  emxArray_real_T *x;
  emxArray_real_T *bg;
  emxArray_real_T *c;
  int32_T ib_size[1];
  emxArray_real_T *insulate_correction;
  uint32_T iters;
  emxArray_real_T *velup;
  emxArray_real_T *varargin_1;
  boolean_T exitg1;
  int32_T b_varargin_1[3];
  boolean_T overflow;
  int32_T varargin_2[3];
  boolean_T p;
  boolean_T exitg2;
  emxArray_int32_T *r0;
  uint32_T x_idx_0;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack g_st;
  emlrtStack h_st;
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
  f_st.prev = &e_st;
  f_st.tls = e_st.tls;
  g_st.prev = &f_st;
  g_st.tls = f_st.tls;
  h_st.prev = &g_st;
  h_st.tls = g_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &emlrtRSI;
  b_st.site = &i_emlrtRSI;
  c_st.site = &j_emlrtRSI;

  /* filter set-up (26 nearest neighbours) */
  /*  hl=ones(3,3,3); */
  /*  hl = hl/26; hl(2,2,2) = 0; */
  /*  filter set-up (6 NN) (safer, especially in cases of coronal non-oblique */
  /*  where dark band is more likely to 'leak' across diagonals */
  memset(&hl[0], 0, 27U * sizeof(real_T));
  for (i0 = 0; i0 < 3; i0++) {
    for (k = 0; k < 3; k++) {
      hl[1 + (3 * k + 9 * i0)] = 1.0;
    }
  }

  for (i0 = 0; i0 < 3; i0++) {
    for (k = 0; k < 3; k++) {
      hl[3 + (k + 9 * i0)] = 1.0;
    }
  }

  for (i0 = 0; i0 < 3; i0++) {
    for (k = 0; k < 3; k++) {
      hl[9 + (k + 3 * i0)] = 1.0;
    }
  }

  hl[13] = 0.0;
  y = (int8_T)hl[0];
  for (k = 0; k < 26; k++) {
    y += (real_T)(int8_T)hl[k + 1];
  }

  for (i0 = 0; i0 < 27; i0++) {
    hl[i0] /= y;
  }

  y = sz[0] * sz[1] * sz[2];
  emxInit_real_T(sp, &elems, 2, &emlrtRTEI, true);
  if (muDoubleScalarIsNaN(y)) {
    i0 = elems->size[0] * elems->size[1];
    elems->size[0] = 1;
    elems->size[1] = 1;
    emxEnsureCapacity_real_T(sp, elems, i0, &emlrtRTEI);
    elems->data[0] = rtNaN;
  } else if (y < 1.0) {
    i0 = elems->size[0] * elems->size[1];
    elems->size[0] = 1;
    elems->size[1] = 0;
    emxEnsureCapacity_real_T(sp, elems, i0, &emlrtRTEI);
  } else if (muDoubleScalarIsInf(y) && (1.0 == y)) {
    i0 = elems->size[0] * elems->size[1];
    elems->size[0] = 1;
    elems->size[1] = 1;
    emxEnsureCapacity_real_T(sp, elems, i0, &emlrtRTEI);
    elems->data[0] = rtNaN;
  } else {
    i0 = elems->size[0] * elems->size[1];
    elems->size[0] = 1;
    elems->size[1] = (int32_T)muDoubleScalarFloor(y - 1.0) + 1;
    emxEnsureCapacity_real_T(sp, elems, i0, &emlrtRTEI);
    loop_ub = (int32_T)muDoubleScalarFloor(y - 1.0);
    for (i0 = 0; i0 <= loop_ub; i0++) {
      elems->data[elems->size[0] * i0] = 1.0 + (real_T)i0;
    }
  }

  /* set up all requisite variables */
  for (i0 = 0; i0 < 3; i0++) {
    if (!(sz[i0] >= 0.0)) {
      emlrtNonNegativeCheckR2012b(sz[i0], &c_emlrtDCI, sp);
    }

    if (sz[i0] != (int32_T)muDoubleScalarFloor(sz[i0])) {
      emlrtIntegerCheckR2012b(sz[i0], &d_emlrtDCI, sp);
    }
  }

  i0 = LP->size[0] * LP->size[1] * LP->size[2];
  LP->size[0] = (int32_T)sz[0];
  LP->size[1] = (int32_T)sz[1];
  LP->size[2] = (int32_T)sz[2];
  emxEnsureCapacity_real_T1(sp, LP, i0, &b_emlrtRTEI);
  loop_ub = (int32_T)sz[0] * (int32_T)sz[1] * (int32_T)sz[2];
  for (i0 = 0; i0 < loop_ub; i0++) {
    LP->data[i0] = rtNaN;
  }

  emxInit_int32_T(sp, &ia, 1, &n_emlrtRTEI, true);
  idx = (int32_T)sz[0] * (int32_T)sz[1] * (int32_T)sz[2];
  i0 = ia->size[0];
  ia->size[0] = fg->size[0];
  emxEnsureCapacity_int32_T(sp, ia, i0, &c_emlrtRTEI);
  loop_ub = fg->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    y = fg->data[i0];
    if (y != (int32_T)muDoubleScalarFloor(y)) {
      emlrtIntegerCheckR2012b(y, &e_emlrtDCI, sp);
    }

    k = (int32_T)y;
    if (!((k >= 1) && (k <= idx))) {
      emlrtDynamicBoundsCheckR2012b(k, 1, idx, &b_emlrtBCI, sp);
    }

    ia->data[i0] = k;
  }

  i0 = ia->size[0];
  k = init->size[0] * init->size[1];
  if (i0 != k) {
    emlrtSubAssignSizeCheck1dR2017a(i0, k, &emlrtECI, sp);
  }

  loop_ub = ia->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    LP->data[ia->data[i0] - 1] = init->data[i0];
  }

  b_LP = LP->size[0] * LP->size[1] * LP->size[2];
  i0 = ia->size[0];
  ia->size[0] = source->size[0];
  emxEnsureCapacity_int32_T(sp, ia, i0, &d_emlrtRTEI);
  loop_ub = source->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    y = source->data[i0];
    if (y != (int32_T)muDoubleScalarFloor(y)) {
      emlrtIntegerCheckR2012b(y, &f_emlrtDCI, sp);
    }

    k = (int32_T)y;
    if (!((k >= 1) && (k <= b_LP))) {
      emlrtDynamicBoundsCheckR2012b(k, 1, b_LP, &c_emlrtBCI, sp);
    }

    ia->data[i0] = k;
  }

  loop_ub = ia->size[0] - 1;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    LP->data[ia->data[i0] - 1] = 0.0;
  }

  b_LP = LP->size[0] * LP->size[1] * LP->size[2];
  i0 = ia->size[0];
  ia->size[0] = sink->size[0];
  emxEnsureCapacity_int32_T(sp, ia, i0, &e_emlrtRTEI);
  loop_ub = sink->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    y = sink->data[i0];
    if (y != (int32_T)muDoubleScalarFloor(y)) {
      emlrtIntegerCheckR2012b(y, &g_emlrtDCI, sp);
    }

    k = (int32_T)y;
    if (!((k >= 1) && (k <= b_LP))) {
      emlrtDynamicBoundsCheckR2012b(k, 1, b_LP, &d_emlrtBCI, sp);
    }

    ia->data[i0] = k;
  }

  loop_ub = ia->size[0] - 1;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    LP->data[ia->data[i0] - 1] = 1.0;
  }

  emxInit_real_T1(sp, &x, 1, &v_emlrtRTEI, true);
  st.site = &b_emlrtRSI;
  i0 = x->size[0];
  x->size[0] = (fg->size[0] + source->size[0]) + sink->size[0];
  emxEnsureCapacity_real_T2(&st, x, i0, &f_emlrtRTEI);
  loop_ub = fg->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    x->data[i0] = fg->data[i0];
  }

  loop_ub = source->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    x->data[i0 + fg->size[0]] = source->data[i0];
  }

  loop_ub = sink->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    x->data[(i0 + fg->size[0]) + source->size[0]] = sink->data[i0];
  }

  emxInit_real_T1(&st, &bg, 1, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &c, 2, &w_emlrtRTEI, true);
  b_st.site = &k_emlrtRSI;
  sort(&b_st, x);
  st.site = &b_emlrtRSI;
  b_st.site = &mb_emlrtRSI;
  c_st.site = &nb_emlrtRSI;
  do_vectors(&c_st, elems, x, c, ia, ib_size);
  i0 = bg->size[0];
  bg->size[0] = c->size[1];
  emxEnsureCapacity_real_T2(sp, bg, i0, &g_emlrtRTEI);
  loop_ub = c->size[1];
  emxFree_real_T(sp, &elems);
  for (i0 = 0; i0 < loop_ub; i0++) {
    bg->data[i0] = c->data[c->size[0] * i0];
  }

  emxFree_real_T(sp, &c);

  /*  bg in indices */
  b_LP = LP->size[0] * LP->size[1] * LP->size[2];
  i0 = ia->size[0];
  ia->size[0] = bg->size[0];
  emxEnsureCapacity_int32_T(sp, ia, i0, &h_emlrtRTEI);
  loop_ub = bg->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    y = bg->data[i0];
    if (y != (int32_T)muDoubleScalarFloor(y)) {
      emlrtIntegerCheckR2012b(y, &h_emlrtDCI, sp);
    }

    k = (int32_T)y;
    if (!((k >= 1) && (k <= b_LP))) {
      emlrtDynamicBoundsCheckR2012b(k, 1, b_LP, &e_emlrtBCI, sp);
    }

    ia->data[i0] = k;
  }

  loop_ub = ia->size[0] - 1;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    LP->data[ia->data[i0] - 1] = 0.0;
  }

  /* must be insulated after filtering */
  i0 = iter_change->size[0] * iter_change->size[1];
  iter_change->size[0] = 1;
  if (!(maxiters >= 0.0)) {
    emlrtNonNegativeCheckR2012b(maxiters, &b_emlrtDCI, sp);
  }

  if (maxiters != (int32_T)muDoubleScalarFloor(maxiters)) {
    emlrtIntegerCheckR2012b(maxiters, &emlrtDCI, sp);
  }

  iter_change->size[1] = (int32_T)maxiters;
  emxEnsureCapacity_real_T(sp, iter_change, i0, &i_emlrtRTEI);
  if (!(maxiters >= 0.0)) {
    emlrtNonNegativeCheckR2012b(maxiters, &j_emlrtDCI, sp);
  }

  if (maxiters != (int32_T)muDoubleScalarFloor(maxiters)) {
    emlrtIntegerCheckR2012b(maxiters, &i_emlrtDCI, sp);
  }

  loop_ub = (int32_T)maxiters;
  for (i0 = 0; i0 < loop_ub; i0++) {
    iter_change->data[i0] = 0.0;
  }

  for (i0 = 0; i0 < 3; i0++) {
    if (sz[i0] != (int32_T)muDoubleScalarFloor(sz[i0])) {
      emlrtIntegerCheckR2012b(sz[i0], &k_emlrtDCI, sp);
    }
  }

  emxInit_real_T2(sp, &insulate_correction, 3, &j_emlrtRTEI, true);
  i0 = insulate_correction->size[0] * insulate_correction->size[1] *
    insulate_correction->size[2];
  insulate_correction->size[0] = (int32_T)sz[0];
  insulate_correction->size[1] = (int32_T)sz[1];
  insulate_correction->size[2] = (int32_T)sz[2];
  emxEnsureCapacity_real_T1(sp, insulate_correction, i0, &j_emlrtRTEI);
  loop_ub = (int32_T)sz[0] * (int32_T)sz[1] * (int32_T)sz[2];
  for (i0 = 0; i0 < loop_ub; i0++) {
    insulate_correction->data[i0] = 0.0;
  }

  idx = (int32_T)sz[0] * (int32_T)sz[1] * (int32_T)sz[2];
  i0 = ia->size[0];
  ia->size[0] = (fg->size[0] + source->size[0]) + sink->size[0];
  emxEnsureCapacity_int32_T(sp, ia, i0, &k_emlrtRTEI);
  loop_ub = fg->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    k = (int32_T)fg->data[i0];
    if (!((k >= 1) && (k <= idx))) {
      emlrtDynamicBoundsCheckR2012b(k, 1, idx, &f_emlrtBCI, sp);
    }

    ia->data[i0] = k;
  }

  loop_ub = source->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    k = (int32_T)source->data[i0];
    if (!((k >= 1) && (k <= idx))) {
      emlrtDynamicBoundsCheckR2012b(k, 1, idx, &f_emlrtBCI, sp);
    }

    ia->data[i0 + fg->size[0]] = k;
  }

  loop_ub = sink->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    k = (int32_T)sink->data[i0];
    if (!((k >= 1) && (k <= idx))) {
      emlrtDynamicBoundsCheckR2012b(k, 1, idx, &f_emlrtBCI, sp);
    }

    ia->data[(i0 + fg->size[0]) + source->size[0]] = k;
  }

  loop_ub = ia->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    insulate_correction->data[ia->data[i0] - 1] = 1.0;
  }

  st.site = &c_emlrtRSI;
  imfilter(&st, insulate_correction, hl);

  /*  apply filter */
  iters = 0U;
  emxInit_real_T2(sp, &velup, 3, &l_emlrtRTEI, true);
  emxInit_real_T1(sp, &varargin_1, 1, &x_emlrtRTEI, true);
  exitg1 = false;
  while ((!exitg1) && (iters < maxiters)) {
    /* max iterations */
    iters++;
    i0 = velup->size[0] * velup->size[1] * velup->size[2];
    velup->size[0] = LP->size[0];
    velup->size[1] = LP->size[1];
    velup->size[2] = LP->size[2];
    emxEnsureCapacity_real_T1(sp, velup, i0, &l_emlrtRTEI);
    loop_ub = LP->size[0] * LP->size[1] * LP->size[2];
    for (i0 = 0; i0 < loop_ub; i0++) {
      velup->data[i0] = LP->data[i0];
    }

    st.site = &d_emlrtRSI;
    imfilter(&st, velup, hl);

    /* apply averaging filter */
    /* insulate the grey matter so gradient doesn't pass between folds - */
    /* inspired by ndnanfilter */
    st.site = &e_emlrtRSI;
    for (i0 = 0; i0 < 3; i0++) {
      b_varargin_1[i0] = velup->size[i0];
    }

    for (i0 = 0; i0 < 3; i0++) {
      varargin_2[i0] = insulate_correction->size[i0];
    }

    overflow = false;
    p = true;
    k = 0;
    exitg2 = false;
    while ((!exitg2) && (k < 3)) {
      if (!(b_varargin_1[k] == varargin_2[k])) {
        p = false;
        exitg2 = true;
      } else {
        k++;
      }
    }

    if (p) {
      overflow = true;
    }

    if (!overflow) {
      emlrtErrorWithMessageIdR2018a(&st, &yb_emlrtRTEI, "MATLAB:dimagree",
        "MATLAB:dimagree", 0);
    }

    loop_ub = velup->size[0] * velup->size[1] * velup->size[2] - 1;
    i0 = velup->size[0] * velup->size[1] * velup->size[2];
    emxEnsureCapacity_real_T1(&st, velup, i0, &o_emlrtRTEI);
    for (i0 = 0; i0 <= loop_ub; i0++) {
      velup->data[i0] /= insulate_correction->data[i0];
    }

    idx = velup->size[0] * velup->size[1] * velup->size[2];
    i0 = ia->size[0];
    ia->size[0] = bg->size[0];
    emxEnsureCapacity_int32_T(sp, ia, i0, &p_emlrtRTEI);
    loop_ub = bg->size[0];
    for (i0 = 0; i0 < loop_ub; i0++) {
      k = (int32_T)bg->data[i0];
      if (!((k >= 1) && (k <= idx))) {
        emlrtDynamicBoundsCheckR2012b(k, 1, idx, &g_emlrtBCI, sp);
      }

      ia->data[i0] = k;
    }

    loop_ub = ia->size[0] - 1;
    for (i0 = 0; i0 <= loop_ub; i0++) {
      velup->data[ia->data[i0] - 1] = 0.0;
    }

    idx = velup->size[0] * velup->size[1] * velup->size[2];
    i0 = ia->size[0];
    ia->size[0] = source->size[0];
    emxEnsureCapacity_int32_T(sp, ia, i0, &q_emlrtRTEI);
    loop_ub = source->size[0];
    for (i0 = 0; i0 < loop_ub; i0++) {
      k = (int32_T)source->data[i0];
      if (!((k >= 1) && (k <= idx))) {
        emlrtDynamicBoundsCheckR2012b(k, 1, idx, &h_emlrtBCI, sp);
      }

      ia->data[i0] = k;
    }

    loop_ub = ia->size[0] - 1;
    for (i0 = 0; i0 <= loop_ub; i0++) {
      velup->data[ia->data[i0] - 1] = 0.0;
    }

    idx = velup->size[0] * velup->size[1] * velup->size[2];
    i0 = ia->size[0];
    ia->size[0] = sink->size[0];
    emxEnsureCapacity_int32_T(sp, ia, i0, &r_emlrtRTEI);
    loop_ub = sink->size[0];
    for (i0 = 0; i0 < loop_ub; i0++) {
      k = (int32_T)sink->data[i0];
      if (!((k >= 1) && (k <= idx))) {
        emlrtDynamicBoundsCheckR2012b(k, 1, idx, &i_emlrtBCI, sp);
      }

      ia->data[i0] = k;
    }

    loop_ub = ia->size[0] - 1;
    for (i0 = 0; i0 <= loop_ub; i0++) {
      velup->data[ia->data[i0] - 1] = 1.0;
    }

    /* stopping condition */
    st.site = &f_emlrtRSI;
    indexShapeCheck(&st, *(int32_T (*)[3])LP->size, fg->size[0]);
    st.site = &f_emlrtRSI;
    indexShapeCheck(&st, *(int32_T (*)[3])velup->size, fg->size[0]);
    b_LP = LP->size[0] * LP->size[1] * LP->size[2];
    loop_ub = fg->size[0];
    for (i0 = 0; i0 < loop_ub; i0++) {
      k = (int32_T)fg->data[i0];
      if (!((k >= 1) && (k <= b_LP))) {
        emlrtDynamicBoundsCheckR2012b(k, 1, b_LP, &j_emlrtBCI, sp);
      }
    }

    idx = velup->size[0] * velup->size[1] * velup->size[2];
    loop_ub = fg->size[0];
    for (i0 = 0; i0 < loop_ub; i0++) {
      k = (int32_T)fg->data[i0];
      if (!((k >= 1) && (k <= idx))) {
        emlrtDynamicBoundsCheckR2012b(k, 1, idx, &k_emlrtBCI, sp);
      }
    }

    i0 = fg->size[0];
    k = fg->size[0];
    if (i0 != k) {
      emlrtSizeEqCheck1DR2012b(i0, k, &b_emlrtECI, sp);
    }

    st.site = &f_emlrtRSI;
    i0 = x->size[0];
    x->size[0] = fg->size[0];
    emxEnsureCapacity_real_T2(&st, x, i0, &s_emlrtRTEI);
    loop_ub = fg->size[0];
    for (i0 = 0; i0 < loop_ub; i0++) {
      x->data[i0] = LP->data[(int32_T)fg->data[i0] - 1] - velup->data[(int32_T)
        fg->data[i0] - 1];
    }

    b_st.site = &qc_emlrtRSI;
    x_idx_0 = (uint32_T)x->size[0];
    i0 = varargin_1->size[0];
    varargin_1->size[0] = (int32_T)x_idx_0;
    emxEnsureCapacity_real_T2(&b_st, varargin_1, i0, &t_emlrtRTEI);
    c_st.site = &rc_emlrtRSI;
    overflow = ((!(1 > x->size[0])) && (x->size[0] > 2147483646));
    if (overflow) {
      d_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&d_st);
    }

    for (k = 0; k < x->size[0]; k++) {
      varargin_1->data[k] = muDoubleScalarAbs(x->data[k]);
    }

    st.site = &f_emlrtRSI;
    b_st.site = &sc_emlrtRSI;
    if ((varargin_1->size[0] == 1) || (varargin_1->size[0] != 1)) {
    } else {
      emlrtErrorWithMessageIdR2018a(&b_st, &ac_emlrtRTEI,
        "Coder:toolbox:autoDimIncompatibility",
        "Coder:toolbox:autoDimIncompatibility", 0);
    }

    if (varargin_1->size[0] == 0) {
      y = 0.0;
    } else {
      y = 0.0;
      c_st.site = &tc_emlrtRSI;
      overflow = (varargin_1->size[0] > 2147483646);
      if (overflow) {
        d_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&d_st);
      }

      for (k = 1; k <= varargin_1->size[0]; k++) {
        i0 = varargin_1->size[0];
        if (!((k >= 1) && (k <= i0))) {
          emlrtDynamicBoundsCheckR2012b(k, 1, i0, &emlrtBCI, &b_st);
        }

        if (!muDoubleScalarIsNaN(varargin_1->data[k - 1])) {
          i0 = varargin_1->size[0];
          if (!((k >= 1) && (k <= i0))) {
            emlrtDynamicBoundsCheckR2012b(k, 1, i0, &l_emlrtBCI, &b_st);
          }

          y += varargin_1->data[k - 1];
        }
      }
    }

    i0 = iter_change->size[1];
    k = (int32_T)iters;
    if (!((k >= 1) && (k <= i0))) {
      emlrtDynamicBoundsCheckR2012b(k, 1, i0, &m_emlrtBCI, sp);
    }

    iter_change->data[k - 1] = y;

    /* compute change from last iteration */
    i0 = LP->size[0] * LP->size[1] * LP->size[2];
    LP->size[0] = velup->size[0];
    LP->size[1] = velup->size[1];
    LP->size[2] = velup->size[2];
    emxEnsureCapacity_real_T1(sp, LP, i0, &u_emlrtRTEI);
    loop_ub = velup->size[0] * velup->size[1] * velup->size[2];
    for (i0 = 0; i0 < loop_ub; i0++) {
      LP->data[i0] = velup->data[i0];
    }

    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }

    i0 = iter_change->size[1];
    k = (int32_T)iters;
    if (!((k >= 1) && (k <= i0))) {
      emlrtDynamicBoundsCheckR2012b(k, 1, i0, &n_emlrtBCI, sp);
    }

    if (iter_change->data[k - 1] < 0.001) {
      exitg1 = true;
    }
  }

  emxFree_real_T(sp, &varargin_1);
  emxFree_int32_T(sp, &ia);
  emxFree_real_T(sp, &x);
  emxFree_real_T(sp, &velup);
  emxFree_real_T(sp, &insulate_correction);
  emxFree_real_T(sp, &bg);
  st.site = &g_emlrtRSI;
  b_st.site = &uc_emlrtRSI;
  c_st.site = &vc_emlrtRSI;
  d_st.site = &wc_emlrtRSI;
  if ((LP->size[0] * LP->size[1] * LP->size[2] == 1) || (LP->size[0] * LP->size
       [1] * LP->size[2] != 1)) {
  } else {
    emlrtErrorWithMessageIdR2018a(&d_st, &bc_emlrtRTEI,
      "Coder:toolbox:autoDimIncompatibility",
      "Coder:toolbox:autoDimIncompatibility", 0);
  }

  if (!(LP->size[0] * LP->size[1] * LP->size[2] >= 1)) {
    emlrtErrorWithMessageIdR2018a(&d_st, &cc_emlrtRTEI,
      "Coder:toolbox:eml_min_or_max_varDimZero",
      "Coder:toolbox:eml_min_or_max_varDimZero", 0);
  }

  e_st.site = &xc_emlrtRSI;
  if (LP->size[0] * LP->size[1] * LP->size[2] <= 2) {
    if (LP->size[0] * LP->size[1] * LP->size[2] == 1) {
      y = LP->data[0];
    } else if ((LP->data[0] < LP->data[1]) || (muDoubleScalarIsNaN(LP->data[0]) &&
                (!muDoubleScalarIsNaN(LP->data[1])))) {
      y = LP->data[1];
    } else {
      y = LP->data[0];
    }
  } else {
    f_st.site = &ad_emlrtRSI;
    if (!muDoubleScalarIsNaN(LP->data[0])) {
      idx = 1;
    } else {
      idx = 0;
      g_st.site = &bd_emlrtRSI;
      overflow = ((!(2 > LP->size[0] * LP->size[1] * LP->size[2])) && (LP->size
        [0] * LP->size[1] * LP->size[2] > 2147483646));
      if (overflow) {
        h_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&h_st);
      }

      k = 2;
      exitg1 = false;
      while ((!exitg1) && (k <= LP->size[0] * LP->size[1] * LP->size[2])) {
        if (!muDoubleScalarIsNaN(LP->data[k - 1])) {
          idx = k;
          exitg1 = true;
        } else {
          k++;
        }
      }
    }

    if (idx == 0) {
      y = LP->data[0];
    } else {
      f_st.site = &yc_emlrtRSI;
      y = LP->data[idx - 1];
      g_st.site = &cd_emlrtRSI;
      overflow = ((!(idx + 1 > LP->size[0] * LP->size[1] * LP->size[2])) &&
                  (LP->size[0] * LP->size[1] * LP->size[2] > 2147483646));
      if (overflow) {
        h_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&h_st);
      }

      while (idx + 1 <= LP->size[0] * LP->size[1] * LP->size[2]) {
        if (y < LP->data[idx]) {
          y = LP->data[idx];
        }

        idx++;
      }
    }
  }

  loop_ub = LP->size[0] * LP->size[1] * LP->size[2] - 1;
  i0 = LP->size[0] * LP->size[1] * LP->size[2];
  emxEnsureCapacity_real_T1(sp, LP, i0, &m_emlrtRTEI);
  for (i0 = 0; i0 <= loop_ub; i0++) {
    LP->data[i0] /= y;
  }

  emxInit_int32_T(sp, &r0, 1, &n_emlrtRTEI, true);
  st.site = &h_emlrtRSI;
  i0 = r0->size[0];
  r0->size[0] = 0;
  emxEnsureCapacity_int32_T(sp, r0, i0, &n_emlrtRTEI);
  loop_ub = r0->size[0] - 1;
  b_LP = LP->size[0];
  idx = LP->size[1];
  k = LP->size[2];
  b_LP = b_LP * idx * k;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    k = r0->data[i0];
    if (!((k >= 1) && (k <= b_LP))) {
      emlrtDynamicBoundsCheckR2012b(k, 1, b_LP, &o_emlrtBCI, sp);
    }

    LP->data[k - 1] = rtNaN;
  }

  emxFree_int32_T(sp, &r0);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (laplace_iters.c) */
