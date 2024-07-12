@echo off
setlocal enabledelayedexpansion

:: Check if the repository name is provided
if "%1"=="" (
  echo Usage: %0 ^<repository_name>^
  exit /b 1
)

:: Set the project path, container name, and image name based on the lowercase repository name
set "REPO_NAME=%1"
set PROJECT_PATH=../%REPO_NAME%
set CONTAINER_NAME=nvim-%REPO_NAME%
set IMAGE_NAME=nvim-%REPO_NAME%
set DEV_SETUP_PATH=./

:: Navigate to the parent directory to create the .env file
cd ..

:: Create or update the .env file
echo DEV_SETUP_PATH=%DEV_SETUP_PATH% > .env
echo CONTAINER_NAME=%CONTAINER_NAME% >> .env
echo IMAGE_NAME=%IMAGE_NAME% >> .env
echo PROJECT_PATH=%PROJECT_PATH% >> .env

:: Navigate back to the scripts directory
cd scripts

:: Ensure any existing containers are stopped and removed
docker-compose down --volumes --remove-orphans

:: Remove the existing image
docker rmi %IMAGE_NAME%

:: Prune Docker system to ensure no residual data
docker system prune --all --volumes --force

:: Rebuild the Docker image to ensure changes are applied
docker-compose build --no-cache

:: Run docker-compose with the environment variables
docker-compose up -d

:: Display the status of the Docker Compose services
docker-compose ps

endlocal
