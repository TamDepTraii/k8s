@echo off
REM Test script for local Docker container

echo.
echo ===== Testing Docker Image Locally =====
echo.

echo Starting container...
docker run -d -p 8080:8080 --name k8s-demo-test k8s-demo:latest

echo Waiting for container to start...
timeout /t 3 /nobreak

echo.
echo Testing endpoints:
echo.

echo 1. Health Check:
curl http://localhost:8080/actuator/health
echo.
echo.

echo 2. Hello World:
curl http://localhost:8080/helloWorld
echo.
echo.

echo 3. Name endpoint:
curl http://localhost:8080/name
echo.
echo.

echo Stopping container...
docker stop k8s-demo-test
docker rm k8s-demo-test

echo.
echo ===== Test Complete =====
echo.
