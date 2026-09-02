#!/bin/bash
# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
# Copyright 2026 Amazon.com, Inc. or its affiliates. All rights reserved.

# Execute commands from a file in parallel and wait for all to complete.

nproc=$(nproc 2>/dev/null)
[[ $nproc =~ ^[1-9][0-9]*$ ]] || nproc=4
max_jobs=$(( nproc / 2 > 0 ? nproc / 2 : 1 ))

pids=()
while IFS= read -r cmd; do
	eval "$cmd" &
	pids+=($!)
	if [[ ${#pids[@]} -ge $max_jobs ]]; then
		wait "${pids[0]}" 2>/dev/null
		pids=("${pids[@]:1}")
	fi
done < "$1"

wait
