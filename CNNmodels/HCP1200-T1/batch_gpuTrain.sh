#!/bin/bash
#SBATCH --account=rrg-lpalaniy
#SBATCH --ntasks=1
#SBATCH --gres=gpu:v100:8
#SBATCH --exclusive
#SBATCH --cpus-per-task=28
#SBATCH --mem=86000M
#SBATCH --time=48:00:00
#SBATCH --output=/scratch/jdekrake/Hippocampal_AutoTop_tests/CNNmodels/highres3dnet_large_v0.7_T1/train.%A.out


module load arch/avx512 StdEnv/2018.3
nvidia-smi

singularity exec -B /scratch/jdekrake:/scratch/jdekrake --nv /scratch/jdekrake/Hippocampal_AutoTop_tests/containers/deeplearning_gpu.simg net_segment -c /scratch/jdekrake/Hippocampal_AutoTop_tests/CNNmodels/highres3dnet_large_v0.7_T1/config.ini train

singularity exec -B /scratch/jdekrake:/scratch/jdekrake --nv /scratch/jdekrake/Hippocampal_AutoTop_tests/containers/deeplearning_gpu.simg net_segment -c /scratch/jdekrake/Hippocampal_AutoTop_tests/CNNmodels/highres3dnet_large_v0.7_T1/config.ini inference

singularity exec -B /scratch/jdekrake:/scratch/jdekrake --nv /scratch/jdekrake/Hippocampal_AutoTop_tests/containers/deeplearning_gpu.simg net_segment -c /scratch/jdekrake/Hippocampal_AutoTop_tests/CNNmodels/highres3dnet_large_v0.7_T1/config.ini evaluation
