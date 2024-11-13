# How to install RegCM on Charlie cloud

## Assumptions

- The working directory is this repository.
- Charlie cloud is installed on the cluster.
- The experiment for RegCM is prepared.

### Build the RegCM

**TL;DR**: You can run the [installation script](./install.sh), and the steps described in this section will be carried out for you. However, you will need to change `$ROOT_DIR` inside the script (see the README inside the script).

Log in to one of the workers, e.g.:

```bash
$> salloc -p gpu-short -A kdss --cpus-per-task=32 --mem=2GB
```

Build base Charlie images *(it can take around 15 minutes)*. The first three are taken from the Charlie Cloud tutorial.

```bash
$> ch-image build -f Dockerfile.almalinux_8ch .
$> ch-image build -f Dockerfile.libfabric .
$> ch-image build -f Dockerfile.openmpi .
$> ch-image build -f Dockerfile.regcm .
```

Convert the RegCM image to a Charlie image. We are using `imgdir` to store the state of the image:

```bash
$> ch-convert -i ch-image -o dir regcm imgdir
```

Congratulations! You have successfully built the RegCM.

### Prepare data and run the RegCM

Assuming you have prepared the experiment, you will now need to edit the [run-on-cluster.sh](./run-on-cluster.sh) script.

In the script, change the marked variables, i.e.:

- `IMGDIR`: Directory containing the converted Charlie Cloud image. If you have followed the installation manual or run the [install.sh](./install.sh) script, the directory should be `<path/to/this/repo>/imgdir`.
- `RUNDIR`: Path to the experiment directory.
- `OUTDIR`: Path to the output directory, relative to `$RUNDIR`.
- `IN_DOMAIN`: Path to the input domain file, relative to `$RUNDIR`. **Important:** RegCM runs in the container, and `RUNDIR` and `OUTDIR` are mounted to `/running_dir` and `/output_dir`, respectively. This means that the paths you provide in your domain file must respect this mapping. For example, the parameter `dirout` should be set as `dirout = '/output_dir'`.
- `SCRATCH_DIR`: Path to the scratch directory for temporary files.

Optional changes:

- You can (and probably should) change the parameters for Slurm at the top of the script.

Once everything ready you can run the RegCM:

```bash
$> sbatch run-on-cluster.sh
```
