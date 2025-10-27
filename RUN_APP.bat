@echo off
REM Quick start script for K8s application

echo.
echo ========================================
echo   K8s Application - Quick Start
echo ========================================
echo.

REM Option 1: Run Spring Boot directly
echo [1] Starting Spring Boot Application...
echo.

call .\mvnw.cmd spring-boot:run

pause

