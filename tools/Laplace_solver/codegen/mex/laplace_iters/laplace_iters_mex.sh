MATLAB="/usr/local/MATLAB/R2018a"
Arch=glnxa64
ENTRYPOINT=mexFunction
MAPFILE=$ENTRYPOINT'.map'
PREFDIR="/home/jordandekraker/.matlab/R2018a"
OPTSFILE_NAME="./setEnv.sh"
. $OPTSFILE_NAME
COMPILER=$CC
. $OPTSFILE_NAME
echo "# Make settings for laplace_iters" > laplace_iters_mex.mki
echo "CC=$CC" >> laplace_iters_mex.mki
echo "CFLAGS=$CFLAGS" >> laplace_iters_mex.mki
echo "CLIBS=$CLIBS" >> laplace_iters_mex.mki
echo "COPTIMFLAGS=$COPTIMFLAGS" >> laplace_iters_mex.mki
echo "CDEBUGFLAGS=$CDEBUGFLAGS" >> laplace_iters_mex.mki
echo "CXX=$CXX" >> laplace_iters_mex.mki
echo "CXXFLAGS=$CXXFLAGS" >> laplace_iters_mex.mki
echo "CXXLIBS=$CXXLIBS" >> laplace_iters_mex.mki
echo "CXXOPTIMFLAGS=$CXXOPTIMFLAGS" >> laplace_iters_mex.mki
echo "CXXDEBUGFLAGS=$CXXDEBUGFLAGS" >> laplace_iters_mex.mki
echo "LDFLAGS=$LDFLAGS" >> laplace_iters_mex.mki
echo "LDOPTIMFLAGS=$LDOPTIMFLAGS" >> laplace_iters_mex.mki
echo "LDDEBUGFLAGS=$LDDEBUGFLAGS" >> laplace_iters_mex.mki
echo "Arch=$Arch" >> laplace_iters_mex.mki
echo "LD=$LD" >> laplace_iters_mex.mki
echo OMPFLAGS= >> laplace_iters_mex.mki
echo OMPLINKFLAGS= >> laplace_iters_mex.mki
echo "EMC_COMPILER=gcc" >> laplace_iters_mex.mki
echo "EMC_CONFIG=optim" >> laplace_iters_mex.mki
"/usr/local/MATLAB/R2018a/bin/glnxa64/gmake" -j 1 -B -f laplace_iters_mex.mk
