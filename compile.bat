@echo off
setlocal EnableDelayedExpansion
set execution_complete=0
set script_folder=%~dp0%
set bin_folder=%script_folder%bin
set program_folder=B:\GodotWindows\Stardusk
set template_folder=%program_folder%\export_templates
set projects_folder=B:\SourceControl\godot_projects
set current_string=""
echo "Welcome, R-r-r-ranger!"
goto set_variables
:check_retry
echo %current_string%
echo "SCONS failed with error code %ERRORLEVEL%."
set    choice=
set /p choice=Would you like to retry? 
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="Y" goto compile
if "%choice%"=="y" goto compile
if "%choice%"=="N" goto quit
if "%choice%"=="n" goto quit

:set_variables
set program_arguments=platform=windows target=release_debug use_llvm=true mbedtls_enabled=yes
set template_arguments_debug=platform=windows tools=no target=release_debug disable_3d=yes mbedtls_enabled=yes
set template_arguments_release=platform=windows tools=no target=release disable_3d=yes mbedtls_enabled=yes
set program_file_name=godot.windows.opt.tools.64
set template_file_name_debug=godot.windows.opt.debug.64
set template_file_name_release=godot.windows.opt.64
set program_final_file_name=godot.exe
set template_final_file_name_debug=windows_64_debug.exe
set template_final_file_name_release=windows_64_release.exe
:: Threads to use in compilation. Max 8, Min 1
set threads=8
:: 0 = Just Program, 1 = Just Templates, 2 = Both Program and Templates
set build_type=-1
:: Whether or not to optimize for build size
set optimize=-1
:: Whether to compile with Mono or not
set mono_enabled=0
goto check_variables

:check_variables
set skip_build_check=0
set skip_optimize_check=0

if not [%1] == [] (
	SET "var="&for /f "delims=0123456789" %%i in ("%1") do set var=%%i
	if not defined var (
		if [%1] GEQ [1] (
			if [%1] LEQ [8] (
				set threads=%1
			)
		)
	)
)
if not [%2] == [] (
	SET "var="&for /f "delims=0123456789" %%i in ("%2") do set var=%%i
	if not defined var (
		if [%2] GEQ [1] (
			if [%2] LEQ [3] (
				set build_type=%2
				set skip_build_check=1
			)
		)
	)
	set first_char=%2
	set first_char=!first_char:~0,1!
	if ["!first_char!"] == ["p"] (
		set build_type=1
		set skip_build_check=1
	)
	if ["!first_char!"] == ["P"] (
		set build_type=1
		set skip_build_check=1
	)
	if ["!first_char!"] == ["t"] (
		set build_type=2
		set skip_build_check=1
	)
	if ["!first_char!"] == ["T"] (
		set build_type=2
		set skip_build_check=1
	)
	if ["!first_char!"] == ["b"] (
		set build_type=3
		set skip_build_check=1
	)
	if ["!first_char!"] == ["B"] (
		set build_type=3
		set skip_build_check=1
	)
)
if not [%3] == [] (
	SET "var="&for /f "delims=0123456789" %%i in ("%3") do set var=%%i
	if not defined var (
		if [%2] GEQ [0] (
		  if [%3] LEQ [1] (
			set optimize=%3
			set skip_optimize_check=1
		  )
	   )
	)
	set first_char=%3
	set first_char=!first_char:~0,1!
	if ["!first_char!"] == ["y"] (
		set optimize=1
		set skip_optimize_check=1
	)
	if ["!first_char!"] == ["Y"] (
		set optimize=1
		set skip_optimize_check=1
	)
	if ["!first_char!"] == ["n"] (
		set optimize=0
		set skip_optimize_check=1
	)
	if ["!first_char!"] == ["N"] (
		set optimize=0
		set skip_optimize_check=1
	)
)
rem if not [%4] == [] (
rem 	if [%4] == ["--mono_enabled"] (
rem 		set mono_enabled=1
rem 	)
rem )
if [%skip_build_check%] EQU [1] (
   if [%skip_optimize_check%] EQU [-1] goto optimize_check
   if [%skip_optimize_check%] EQU [0] goto optimize_check
   goto set_compilation_variables
)
if [%build_type%] EQU [-]1 goto build_check
:build_check
set choice=
set /p choice=Would You like to compile the Program, the Export Templates, or both? 
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="P" set build_type=1
if "%choice%"=="p" set build_type=1
if "%choice%"=="T" set build_type=2
if "%choice%"=="t" set build_type=2
if "%choice%"=="B" set build_type=3
if "%choice%"=="b" set build_type=3
if "%choice%"=="Q" goto quit
if "%choice%"=="q" goto quit

if [%skip_optimize_check%] EQU [1] goto set_compilation_variables
:optimize_check
set choice=
set /p choice=Would You like to optimize for build size? 
if not "%choice%"=="" set choice=%choice:~0,1%
if "%choice%"=="Y" set optimize=1
if "%choice%"=="y" set optimize=1
if "%choice%"=="N" set optimize=0
if "%choice%"=="n" set set optimize=0
if "%choice%"=="Q" goto quit
if "%choice%"=="q" goto quit
goto set_compilation_variables
:set_compilation_variables
set program_arguments=-j%threads% %program_arguments%
set template_arguments_debug=-j%threads% %template_arguments_debug%
set template_arguments_release=-j%threads% %template_arguments_release%
if [%optimize%] EQU [1] (
	set program_arguments=%program_arguments% use_lto=yes
	set template_arguments_debug=%template_arguments_debug% use_lto=yes
	set template_arguments_release=%template_arguments_release% use_lto=yes
) else (
	set program_arguments=%program_arguments% use_llvm=yes use_lld=yes
	set template_arguments_debug=%template_arguments_debug% use_llvm=yes use_lld=yes
	set template_arguments_release=%template_arguments_release% use_llvm=yes use_lld=yes
   rem  set program_file_name=%program_file_name%.llvm
   rem  set template_file_name_debug=%template_file_name_debug%.llvm
   rem  set template_file_name_release=%template_file_name_release%.llvm
)
set current_string=%current_string% Variables:
set current_string=%current_string%\n\tThreads = %threads%
set current_string=%current_string%\n\tBuild Type = 
if [%build_type%] EQU [1] set current_string=%current_string%Program
if [%build_type%] EQU [2] set current_string=%current_string%Templates
if [%build_type%] EQU [3] set current_string=%current_string%Program and Templates
set current_string=%current_string%\n\tOptimize = 
if [%optimize%] EQU [1] (
   set current_string=%current_string%True
) else (
   set current_string=%current_string%False
)
rem if [%mono_enabled%] EQU [1] (
rem 	set program_arguments=%program_arguments% module_mono_enabled=yes mono_glue=yes
rem 	set template_arguments_debug=%template_arguments_debug% module_mono_enabled=yes mono_glue=yes
rem 	set template_arguments_release=%template_arguments_release% module_mono_enabled=yes mono_glue=yes
rem 	set program_file_name=%program_file_name%.mono
rem 	set template_file_name_debug=%template_file_name_debug%.mono
rem 	set template_file_name_release=%template_file_name_release%.mono
rem )
rem echo %current_string%
goto compile
:compile
if [%build_type%] EQU [1] goto c_program
if [%build_type%] EQU [3] goto c_program
goto c2
:c_program
scons %program_arguments%
if not [%ERRORLEVEL%] EQU [0] (
   goto check_retry
)
:c2
if [%build_type%] EQU [2] goto c_templates
if [%build_type%] EQU [3] goto c_templates
goto copy_files_main
:c_templates
call scons %template_arguments_debug%
if not [%ERRORLEVEL%] EQU [0] (
   goto check_retry
) else (
   call scons %template_arguments_release%
   if not [%ERRORLEVEL%] EQU [0] goto check_retry
)
goto copy_files_main
:copy_files_main
if [%build_type%] EQU [1] goto copy_program
if [%build_type%] EQU [3] goto copy_program
goto copy2
:copy_program
xcopy /y "%bin_folder%\%program_file_name%.exe" "%program_folder%\%program_final_file_name%"
if [%optimize%] EQU [1] strip %program_folder%\%program_final_file_name%
goto copy2
:copy2
if [%build_type%] EQU [2] goto copy_templates
if [%build_type%] EQU [3] goto copy_templates
goto quit
:copy_templates
xcopy /y %bin_folder%\%template_file_name_debug%.exe %template_folder%\%template_final_file_name_debug%
xcopy /y %bin_folder%\%template_file_name_release%.exe %template_folder%\%template_final_file_name_release%
if [%optimize%] EQU [1] (
	strip %template_folder%\%template_final_file_name_debug%
	strip %template_folder%\%template_final_file_name_release%
)
goto quit

:quit
echo "Compilation complete. Have a nice day, Ranger!"