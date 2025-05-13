@echo off
setlocal EnableDelayedExpansion

set main_batch_folder=B:\SourceControl\_BATCH
set threads=16

CALL "%main_batch_folder%\compile.bat" --compile_path="%~dp0" --threads=!threads! --program=false --templates=true --export_path=B:\GodotWindows\Godot4.5\

pause
