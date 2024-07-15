@echo off
setlocal enabledelayedexpansion

:: Check if the repository name is provided
if "%~1"=="" (
  echo Usage: %0 ^<repository_name^>
  exit /b 1
)

:: Convert repository name to lowercase
set "REPO_NAME=%~1"
set "REPO_NAME_LOWER="
for /L %%I in (0,1,255) do (
    set "char=!REPO_NAME:~%%I,1!"
    if not "!char!"=="" (
        for %%C in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") do (
            set "char=!char:%%~C!"
        )
        set "REPO_NAME_LOWER=!REPO_NAME_LOWER!!char!"
    )
)
echo !REPO_NAME_LOWER!

:: Use the lowercase repository name for the rest of the script
:: We assume we only fire up one nvim container per script, otherwise
:: we would hava to augement the CONTAINER_NAME with  %RANDOM%
set "PROJECT_PATH=../!REPO_NAME_LOWER!"
set "CONTAINER_NAME=nvim-!REPO_NAME_LOWER!"
set "IMAGE_NAME=nvim-!REPO_NAME_LOWER!"
set "DEV_SETUP_PATH=./"
set "PROJECT_NAME=nvim-container-!REPO_NAME_LOWER!"

:: Navigate to the parent directory to create the .env file
cd ..

:: Create or update the .env file
echo DEV_SETUP_PATH=%DEV_SETUP_PATH% > .env
echo CONTAINER_NAME=%CONTAINER_NAME% >> .env
echo IMAGE_NAME=%IMAGE_NAME% >> .env
echo PROJECT_PATH=%PROJECT_PATH% >> .env
echo PROJECT_NAME=%PROJECT_NAME% >> .env

:: Navigate back to the scripts directory
cd scripts

:: Rebuild the Docker image to ensure changes are applied
docker-compose -p %PROJECT_NAME% -f ../docker-compose.yml build --no-cache

:: Run docker-compose with the environment variables
docker-compose -p %PROJECT_NAME% -f ../docker-compose.yml up -d

:: Display the status of the Docker Compose services
docker-compose -p %PROJECT_NAME% -f ../docker-compose.yml ps

endlocal
