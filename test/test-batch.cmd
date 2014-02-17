@echo off
for /L %%i IN (%1, %2, %3) DO (
  echo %%i
)
