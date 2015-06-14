@echo off
haxe starling-shared.hxml
if %ERRORLEVEL% neq 0 (
	exit /b
)
copy /b starling-shared.hxml+starling-shared.hxml.part starling-export.hxml
haxe starling-export.hxml