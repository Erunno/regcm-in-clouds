#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --job-name=regcm
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --mem-per-cpu=6GB
#SBATCH -A kdss
#SBATCH -p gpu-long
#SBATCH --gpus=0
#SBATCH --output=slurm-out/%x-%j.out
#SBATCH --error=slurm-out/%x-%j.err

#### parlab -p mpi-homo-short


JOBNAME=$SLURM_JOB_NAME-$SLURM_JOB_ID
echo "Starting job: $JOBNAME at $(date)"

########################################
#                                      #
#   Change variables below as needed:  #
#                                      #
########################################

# Converted Charlie Cloud image directory
IMGDIR=$HOME/phd/atm_sym/in-cloud/imgdir

# Path to the experiment
RUNDIR=$HOME/phd/atm_sym/in-cloud/foci_27
# Path to input domain file - relative to $RUNDIR
IN_DOMAIN=foci_27km.in
# Path to output directory - relative to $RUNDIR
OUTDIR=output

# Note: this variable is currently unused
SCRATCH_DIR=$HOME/phd/atm_sym/in-cloud/scratch/$SLURM_JOB_ID

#################################
# do not change below this line #
#################################

# Variables defined in `Dockerfile.regcm`
IN_IMG_RUNDIR=/running_dir
IN_IMG_REGCM=/code/RegCM/bin/regcmMPICLM45

FULL_INDOMAIN=$RUNDIR/$IN_DOMAIN
FULL_OUTDIR=$RUNDIR/$OUTDIR/$JOBNAME

if [ ! -d $SCRATCH_DIR ] ; then
    mkdir -p $SCRATCH_DIR
fi

if [ ! -d $FULL_OUTDIR ] ; then
    mkdir -p $FULL_OUTDIR
fi

# TODO recover after failure

ch-run \
    -b $RUNDIR:/running_dir \
    -b $FULL_OUTDIR:/output_dir \
    $IMGDIR -- \
    /bin/bash -c "\
        cd $IN_IMG_RUNDIR && \
        $IN_IMG_REGCM $IN_DOMAIN"
