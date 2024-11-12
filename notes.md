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

*Note that in this example the container has to contain directories `/input`, `/output` and `/recovery` (otherwise the run fails during attempt to make them). These directories are bounded to the outside `/home/brabecm4/phd/atm_sym/in-cloud/test-in`, `/home/brabecm4/phd/atm_sym/in-cloud/test-out` and `/home/brabecm4/phd/atm_sym/in-cloud/test-recovery` respectively.*

#### Variable

There is also a variant using a variable `$CH_IMAGE_STORAGE` (see [doc](https://hpc.github.io/charliecloud/ch-image.html#storage-directory)). It might be useful for usage in script (??).
