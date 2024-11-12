#!/bin/bash
#SBATCH --nodes=4
#SBATCH --job-name=regcm
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2GB
#SBATCH -p gpu-short
#SBATCH --gres=gpu:V100
#SBATCH -A kdss

echo "Starting job: $SLURM_JOB_NAME-$SLURM_JOB_ID at $(date)"

########################################
#                                      #
#   Change variables below as needed:  #
#                                      #
########################################

# Converted Charlie Cloud image directory
IMGDIR=$HOME/phd/atm_sym/in-cloud/imgdir

RUNDIR=$HOME/phd/atm_sym/in-cloud/foci_27
IN_DOMAIN=foci_27km.in

SCRATCH_DIR=$HOME/phd/atm_sym/in-cloud/scratch/$SLURM_JOB_ID

#################################
# do not change below this line #
#################################

# variables as defined in Dockerfile.regcm
IN_IMG_RUNDIR=/running_dir
IN_IMG_REGCM=/code/RegCM/bin/regcmMPICLM45

if [ ! -d $SCRATCH_DIR ] ; then
    mkdir -p $SCRATCH_DIR
fi

# TODO recover after failure

srun ch-run -b $RUNDIR:/running_dir $IMGDIR -- /bin/bash -c "\
    cd $IN_IMG_RUNDIR && \
    $IN_IMG_REGCM $IN_DOMAIN"
