# Some notes that might be useful

Notes are not in any particular order.

## Charlie cloud

Notes regarding Charlie Cloud

### Connect to image

Assuming that the image is converted using `ch-convert` (see [README](README.md)) and its content are in directory `imgdir`.

```bash
$> ch-run imgdir -- /bin/bash
```

### VOLUMES and bindings

Charlie cloud does not support `VOLUMES` and does not intent to in the future. In order to bind some outside word directories use option `-b` of `ch-run`:

```bash
$> ch-run -b <path/to/outside/dir/to/be/mounted>:<path/inside/of/the/image>
```

e.g.

```bash
$> ch-run -b /home/brabecm4/phd/atm_sym/in-cloud/test-in:/input -b /home/brabecm4/phd/atm_sym/in-cloud/test-out:/output -b /home/brabecm4/phd/atm_sym/in-cloud/test-recovery:/recovery /home/brabecm4/phd/atm_sym/in-cloud/imgdir
```

*Note that in the example the container has to contain directories `/input`, `/output` and `/recovery` (otherwise the run fails during attempt to make them). These directories are bounded to the outside `/home/brabecm4/phd/atm_sym/in-cloud/test-in`, `/home/brabecm4/phd/atm_sym/in-cloud/test-out` and `/home/brabecm4/phd/atm_sym/in-cloud/test-recovery` respectively.*

### Run MPI program

Connect to workers:

```bash
$> salloc -p gpu-short --gres=gpu:V100 -A kdss -N2 --nodelist=volta[01-05]
```

Next run the program using `srun` and and `ch-run`:

```bash
$> srun -c1 ch-run ~/phd/ch-cloud-test/mpi-hello/imgdir/ -- /home/mpiuser/hello
$> srun -c1 ch-run <path/to/image/dir> -- <path/to/mpi/program>
```

#### sbatch MPI program

script for sbatch:

```bash
#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2GB
#SBATCH -p gpu-short
#SBATCH -A kdss
#SBATCH --gres=gpu:V100

ch-run ~/phd/ch-cloud-test/mpi-hello/imgdir/ -- /home/mpiuser/hello
```

Run with:

```bash
$> sbatch <path/to/script/above>
```

*Note: For some strange reason the MPI program does not work when `--gres=gpu:V100` is omitted ¯\_(ツ)_/¯. (On parlab it does)*
