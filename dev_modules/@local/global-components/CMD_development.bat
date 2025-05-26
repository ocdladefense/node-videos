@ECHO OFF

ECHO ----------------
ECHO 1 - [ development - git reset --soft HEAD~1 ]
ECHO 2 - [ development - git push origin +main --force ]
ECHO ----------------

SET /P input="ENTER: "

IF %input% == 1 (
    CALL git reset --soft HEAD~1
)

IF %input% == 2 (
    CALL git push origin +main --force
)

ECHO ----------------

ECHO FINISHED

PAUSE
