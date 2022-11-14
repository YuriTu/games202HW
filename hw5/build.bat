@REM rd /s /q build
@REM mkdir build
cmake -S . -B build
@REM cp -r src/examples build/Release/examples
cmake --build build --config Release