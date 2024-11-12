# How to install RegCM on Charlie cloud

## Assumptions

- Working directory is this repository
- Charlie cloud is installed on the cluster

Log to one of the workers, e.g.:

```bash
$> salloc -p gpu-short -A kdss --cpus-per-task=32 --mem=2GB
```

Build base Charlie images *(it can take something like 15mins)*. First tree are taken from Charlie Cloud tutorial.

```bash
$> ch-image build -f Dockerfile.almalinux_8ch .
$> ch-image build -f Dockerfile.libfabric .
$> ch-image build -f Dockerfile.openmpi .
$> ch-image build -f Dockerfile.regcm .
```

Convert RegCM image to Charlie image. We are using `imgdir` to store the state of the image:

```bash
$> ch-convert -i ch-image -o dir regcm imgdir
```
