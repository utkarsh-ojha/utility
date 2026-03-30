#!/usr/bin/env bats
# =============================================================================
# Tests for clip — Clipboard History Manager
# =============================================================================

CLIP="$BATS_TEST_DIRNAME/../mac/clip/clip"

setup() {
  export HOME="$BATS_TEST_TMPDIR"
  export CLIP_HISTORY="$BATS_TEST_TMPDIR/.clip_history"
  rm -f "$BATS_TEST_TMPDIR/.clip_history"
  rm -f "$BATS_TEST_TMPDIR/.clip_watcher.pid"
  rm -f "$BATS_TEST_TMPDIR/.clip_paused"
  touch "$BATS_TEST_TMPDIR/.clip_history"
}

teardown() {
  # Kill any watcher we may have started
  if [[ -f "$BATS_TEST_TMPDIR/.clip_watcher.pid" ]]; then
    local pid
    pid=$(cat "$BATS_TEST_TMPDIR/.clip_watcher.pid" 2>/dev/null)
    kill "$pid" 2>/dev/null || true
    rm -f "$BATS_TEST_TMPDIR/.clip_watcher.pid"
  fi
  rm -f "$BATS_TEST_TMPDIR/.clip_history"
  rm -f "$BATS_TEST_TMPDIR/.clip_paused"
}

# ─── Help ─────────────────────────────────────────────────────────────────────

@test "clip help exits 0" {
  run bash "$CLIP" help
  [ "$status" -eq 0 ]
}

@test "clip --help exits 0" {
  run bash "$CLIP" --help
  [ "$status" -eq 0 ]
}

@test "clip -h exits 0" {
  run bash "$CLIP" -h
  [ "$status" -eq 0 ]
}

@test "help output contains version" {
  run bash "$CLIP" help
  [[ "$output" == *"clip v"* ]]
}

@test "help output contains UTKARSH OJHA" {
  run bash "$CLIP" help
  [[ "$output" == *"UTKARSH OJHA"* ]]
}

@test "help output contains Clipboard History Manager" {
  run bash "$CLIP" help
  [[ "$output" == *"Clipboard History Manager"* ]]
}

@test "help lists pause command" {
  run bash "$CLIP" help
  [[ "$output" == *"pause"* ]]
}

@test "help lists resume command" {
  run bash "$CLIP" help
  [[ "$output" == *"resume"* ]]
}

# ─── Unknown command ──────────────────────────────────────────────────────────

@test "unknown command shows error" {
  run bash "$CLIP" foobar
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unknown"* ]]
}

# ─── History ──────────────────────────────────────────────────────────────────

@test "clip history with empty file shows message" {
  run bash "$CLIP" history
  [ "$status" -eq 0 ]
  [[ "$output" == *"empty"* ]] || [[ "$output" == *"No"* ]] || [[ "$output" == *"no"* ]]
}

@test "clip history shows entries" {
  # Add a base64 entry (simulate watcher)
  local ts
  ts=$(date '+%Y-%m-%d %H:%M:%S')
  local encoded
  encoded=$(echo -n "hello world" | base64)
  echo "${ts} | ${encoded}" >> "$BATS_TEST_TMPDIR/.clip_history"
  run bash "$CLIP" history
  [ "$status" -eq 0 ]
  [[ "$output" == *"hello world"* ]]
}

@test "clip history respects count argument" {
  local ts
  ts=$(date '+%Y-%m-%d %H:%M:%S')
  for i in 1 2 3 4 5; do
    local encoded
    encoded=$(echo -n "entry $i" | base64)
    echo "${ts} | ${encoded}" >> "$BATS_TEST_TMPDIR/.clip_history"
  done
  run bash "$CLIP" history 2
  [ "$status" -eq 0 ]
  # Should show entries (at least the last 2)
  [[ "$output" == *"entry"* ]]
}

# ─── Copy ─────────────────────────────────────────────────────────────────────

@test "clip copy without number shows error" {
  run bash "$CLIP" copy
  [ "$status" -eq 1 ]
}

@test "clip copy out of range shows error" {
  run bash "$CLIP" copy 999
  [ "$status" -eq 1 ]
}

@test "clip copy valid entry succeeds" {
  local ts
  ts=$(date '+%Y-%m-%d %H:%M:%S')
  local encoded
  encoded=$(echo -n "test copy" | base64)
  echo "${ts} | ${encoded}" >> "$BATS_TEST_TMPDIR/.clip_history"
  run bash "$CLIP" copy 1
  [ "$status" -eq 0 ]
  [[ "$output" == *"Copied"* ]] || [[ "$output" == *"copied"* ]]
}

# ─── Remove ──────────────────────────────────────────────────────────────────

@test "clip remove without number shows error" {
  run bash "$CLIP" remove
  [ "$status" -eq 1 ]
}

@test "clip remove out of range shows error" {
  run bash "$CLIP" remove 999
  [ "$status" -eq 1 ]
}

@test "clip remove valid entry succeeds" {
  local ts
  ts=$(date '+%Y-%m-%d %H:%M:%S')
  local encoded
  encoded=$(echo -n "to remove" | base64)
  echo "${ts} | ${encoded}" >> "$BATS_TEST_TMPDIR/.clip_history"
  run bash "$CLIP" remove 1
  [ "$status" -eq 0 ]
  [[ "$output" == *"Removed"* ]] || [[ "$output" == *"removed"* ]]
  # Verify the file is now empty
  local count
  count=$(wc -l < "$BATS_TEST_TMPDIR/.clip_history" | tr -d ' ')
  [ "$count" -eq 0 ]
}

# ─── Search ──────────────────────────────────────────────────────────────────

@test "clip search without query shows error" {
  run bash "$CLIP" search
  [ "$status" -eq 1 ]
}

@test "clip search finds matching entries" {
  local ts
  ts=$(date '+%Y-%m-%d %H:%M:%S')
  local encoded
  encoded=$(echo -n "the secret api key" | base64)
  echo "${ts} | ${encoded}" >> "$BATS_TEST_TMPDIR/.clip_history"
  encoded=$(echo -n "nothing here" | base64)
  echo "${ts} | ${encoded}" >> "$BATS_TEST_TMPDIR/.clip_history"
  run bash "$CLIP" search "api key"
  [ "$status" -eq 0 ]
  [[ "$output" == *"api key"* ]] || [[ "$output" == *"1 match"* ]] || [[ "$output" == *"match"* ]]
}

@test "clip search with no matches reports none" {
  local ts
  ts=$(date '+%Y-%m-%d %H:%M:%S')
  local encoded
  encoded=$(echo -n "hello world" | base64)
  echo "${ts} | ${encoded}" >> "$BATS_TEST_TMPDIR/.clip_history"
  run bash "$CLIP" search "zzz_not_found_zzz"
  [ "$status" -eq 0 ]
  [[ "$output" == *"No"* ]] || [[ "$output" == *"no"* ]] || [[ "$output" == *"0 match"* ]]
}

# ─── Status ──────────────────────────────────────────────────────────────────

@test "clip status exits 0" {
  run bash "$CLIP" status
  [ "$status" -eq 0 ]
}

@test "clip status reports watcher state" {
  run bash "$CLIP" status
  [[ "$output" == *"Watcher"* ]] || [[ "$output" == *"watcher"* ]] || [[ "$output" == *"running"* ]]
}

# ─── Pause / Resume ──────────────────────────────────────────────────────────

@test "clip pause creates pause file" {
  run bash "$CLIP" pause
  [ "$status" -eq 0 ]
  [ -f "$BATS_TEST_TMPDIR/.clip_paused" ]
}

@test "clip pause reports already paused" {
  touch "$BATS_TEST_TMPDIR/.clip_paused"
  run bash "$CLIP" pause
  [ "$status" -eq 0 ]
  [[ "$output" == *"already paused"* ]] || [[ "$output" == *"Already paused"* ]]
}

@test "clip resume removes pause file" {
  touch "$BATS_TEST_TMPDIR/.clip_paused"
  run bash "$CLIP" resume
  [ "$status" -eq 0 ]
  [ ! -f "$BATS_TEST_TMPDIR/.clip_paused" ]
}

@test "clip resume reports not paused" {
  run bash "$CLIP" resume
  [ "$status" -eq 0 ]
  [[ "$output" == *"not paused"* ]] || [[ "$output" == *"Not paused"* ]]
}

@test "clip status shows paused when pause file exists" {
  touch "$BATS_TEST_TMPDIR/.clip_paused"
  run bash "$CLIP" status
  [ "$status" -eq 0 ]
  [[ "$output" == *"paused"* ]] || [[ "$output" == *"Paused"* ]]
}
