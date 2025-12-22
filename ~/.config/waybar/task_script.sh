#!/bin/bash

TASK_FILE="/home/simon/repos/plan/Innan-1.md"

TASK=$(grep -m1 "^- \[ \]" "$TASK_FILE" | sed 's/- \[ \] //')

if [ -n "$TASK" ]; then

    echo "{\"text\": \"$TASK\", \"tooltip\": \"Top task from $TASK_FILE\"}"

else

    echo "{\"text\": \"No tasks\", \"tooltip\": \"No incomplete tasks found\"}"

fi