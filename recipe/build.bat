@echo on

:: x86-64-v3-equivalent baseline for Windows clang-cl (AVX2 + FMA + BMI).
:: The conda-forge x86_64-microarch-level package is Unix-only, so set the ISA
:: baseline manually here. Note: there is no __archspec runtime guard on Windows.
set "CFLAGS=%CFLAGS% /arch:AVX2"
set "CXXFLAGS=%CXXFLAGS% /arch:AVX2"

:: configure
cmake ^
    -S %SRC_DIR% -B build           ^
    %CMAKE_ARGS%                    ^
    -G "Ninja"                      ^
    -DBUILD_SHARED_LIBS=ON          ^
    -DCMAKE_BUILD_TYPE=Release      ^
    -DCMAKE_C_COMPILER=clang-cl     ^
    -DCMAKE_CXX_COMPILER=clang-cl   ^
    -DCMAKE_INSTALL_LIBDIR=%LIBRARY_PREFIX%/lib      ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_LINKER=lld-link         ^
    -DCMAKE_NM=llvm-nm              ^
    -DCMAKE_VERBOSE_MAKEFILE=ON     ^
    -DpyAMReX_amrex_internal=OFF    ^
    -DpyAMReX_pybind11_internal=OFF ^
    -DAMReX_FFTW_IGNORE_OMP=ON     ^
    -DPython_EXECUTABLE=%PYTHON%    ^
    -DPYINSTALLOPTIONS="--no-build-isolation"
if errorlevel 1 exit 1

:: build, pack & install
cmake --build build --config Release --parallel %CPU_COUNT% --target install
if errorlevel 1 exit 1
cmake --build build --config Release --parallel %CPU_COUNT% --target pip_install_nodeps
if errorlevel 1 exit 1
