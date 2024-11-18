
ROOT_DIR=~/phd/atm_sym/in-cloud 
REGCM_DIR=$ROOT_DIR/RegCM
IMGDIR=imgdir

cd $ROOT_DIR

echo -e "\e[32mConverting image \e[35mregcm-env\e[32m to directory \e[35mimgdir\e[0m"
ch-convert -i ch-image -o dir regcm-env imgdir

echo -e "\e[32mCompiling \e[35mRegCM\e[0m"
ch-run \
    -b $REGCM_DIR:/code/RegCM \
    $IMGDIR -- \
    /bin/bash -c "\
        cd /code/RegCM && \
        autoreconf -f -i && \
        ./configure --enable-clm45 && \
        make && \
        make install"
