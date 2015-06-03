bbpConfigPath () {
    addToSearchPath CMAKE_MODULE_PATH $bbpconfig/share/bbp-cmake
}

if test -n "$crossConfig"; then
    crossEnvHooks+=(bbpConfigPath)
else
    envHooks+=(bbpConfigPath)
fi
