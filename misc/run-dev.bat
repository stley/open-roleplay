@echo off
:: Runs run-dev.ps1 with ExecutionPolicy bypassed.
:: Usage: run-dev.bat            -> latest dev PR artifact
::        run-dev.bat 123        -> PR #123
::        run-dev.bat -Pr 123    -> explicit
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0run-dev.ps1" %*