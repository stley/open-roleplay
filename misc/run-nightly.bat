@echo off
:: Runs run-nightly.ps1 with ExecutionPolicy bypassed.
:: Usage: run-nightly.bat
::        run-nightly.bat -Name nightly-main
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0run-nightly.ps1" %*