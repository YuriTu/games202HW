rd /s /q build
mkdir build
cmake -S . -B build
@REM cp -r src/examples build/Release/examples
cmake --build build --config Release