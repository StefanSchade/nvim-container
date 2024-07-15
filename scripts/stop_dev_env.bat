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
set "CONTAINER_NAME=nvim-!REPO_NAME_LOWER!-%RANDOM%"
set "IMAGE_NAME=nvim-!REPO_NAME_LOWER!"
set "PROJECT_NAME=nvim-container-!REPO_NAME_LOWER!"

:: Navigate to the parent directory
cd ..

:: Stop and remove only the nvim-container related services
docker-compose -p %PROJECT_NAME% -f docker-compose.yml down --volumes --remove-orphans

:: Remove the existing image
docker rmi %IMAGE_NAME%

endlocal
