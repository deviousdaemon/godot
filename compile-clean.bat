@echo off
setlocal EnableDelayedExpansion

set main_batch_folder="B:\SourceControl\_BATCH"
set threads=12

CALL %main_batch_folder%\compile.bat  --clean=true --compile_path="%cd%" --version_string=4.4.dev --threads=!threads! --program=true --export_path=B:\GodotWindows\Godot4.4\