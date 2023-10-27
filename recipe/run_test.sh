#!/usr/bin/env bash

set -eu -x -o pipefail

export OMP_NUM_THREADS=2

# MPI variants
#   see https://github.com/conda-forge/hdf5-feedstock/blob/master/recipe/mpiexec.sh
if [[ "$mpi" == "mpich" ]]; then
    export HYDRA_LAUNCHER=fork
    #export HYDRA_LAUNCHER=ssh
fi
if [[ "$mpi" == "openmpi" ]]; then
    export OMPI_MCA_btl=self,tcp
    export OMPI_MCA_plm=isolated
    #export OMPI_MCA_plm=ssh
    export OMPI_MCA_rmaps_base_oversubscribe=yes
    export OMPI_MCA_btl_vader_single_copy_mechanism=none
fi

$PYTHON -m pytest tests/
