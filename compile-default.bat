@echo off
setlocal EnableDelayedExpansion

set threads=6

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

CALL compile.bat %threads% p 0