@echo off
setlocal

:: Check if the repository name is provided
if "%1"=="" (
  echo Usage: %0 ^<repository_name^>
  exit /b 1
)

:: Set the project path, container name, and image name based on the repository name
set REPO_NAME=%1
set PROJECT_PATH=../%REPO_NAME%
set CONTAINER_NAME=nvim-%REPO_NAME%
set IMAGE_NAME=nvim-%REPO_NAME%

:: Create or update the .env file
echo DEV_SETUP_PATH=./ > .env
echo CONTAINER_NAME=%CONTAINER_NAME% >> .env
echo IMAGE_NAME=%IMAGE_NAME% >> .env
echo PROJECT_PATH=%PROJECT_PATH% >> .env

:: clear existing image
docker-compose -p %CONTAINER_NAME% down --volumes --remove-orphans
docker rmi %IMAGE_NAME%

:: rebuild container
docker-compose build --no-cache

endlocal
