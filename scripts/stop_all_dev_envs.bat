@echo off
setlocal enabledelayedexpansion

echo Stopping all nvim-container related services...

:: Stop and remove all nvim-container related services
for /f "tokens=*" %%i in ('docker ps -a --filter "name=nvim-" --format "{{.Names}}"') do (
    docker-compose -f ../docker-compose.yml -p %%i down --volumes --remove-orphans
)

echo Removing all nvim-container related images...

:: Remove all nvim-container images
for /f "tokens=*" %%i in ('docker images --filter "reference=nvim-*" --format "{{.Repository}}:{{.Tag}}"') do (
    docker rmi %%i
)

echo All nvim-container related services and images have been stopped and removed.

endlocal
