#!/usr/bin/env bats
# =============================================================================
# Tests for portman — Port Manager
# =============================================================================

PORTMAN="$BATS_TEST_DIRNAME/../mac/portman/portman"

setup() {
  export PORTMAN_DATA_DIR="$BATS_TEST_TMPDIR/.portman"
  export HOME="$BATS_TEST_TMPDIR"
  mkdir -p "$PORTMAN_DATA_DIR"
  touch "$PORTMAN_DATA_DIR/history"
}

teardown() {
  rm -rf "$BATS_TEST_TMPDIR/.portman"
}

# ─── Help ─────────────────────────────────────────────────────────────────────

@test "portman help exits 0" {
  run bash "$PORTMAN" help
  [ "$status" -eq 0 ]
}

@test "portman --help exits 0" {
  run bash "$PORTMAN" --help
  [ "$status" -eq 0 ]
}

@test "portman -h exits 0" {
  run bash "$PORTMAN" -h
  [ "$status" -eq 0 ]
}

@test "help output contains version" {
  run bash "$PORTMAN" help
  [[ "$output" == *"portman v"* ]]
}

@test "help output contains UTKARSH OJHA" {
  run bash "$PORTMAN" help
  [[ "$output" == *"UTKARSH OJHA"* ]]
}

@test "help output contains Port Manager" {
  run bash "$PORTMAN" help
  [[ "$output" == *"Port Manager"* ]]
}

# ─── Unknown command ──────────────────────────────────────────────────────────

@test "unknown command shows error" {
  run bash "$PORTMAN" foobar
  [ "$status" -eq 1 ]
}

# ─── List ─────────────────────────────────────────────────────────────────────

@test "portman list exits 0" {
  run bash "$PORTMAN" list
  [ "$status" -eq 0 ]
}

@test "portman list output contains header" {
  run bash "$PORTMAN" list
  [[ "$output" == *"Active"* ]] || [[ "$output" == *"PORT"* ]] || [[ "$output" == *"port"* ]]
}

# ─── Port check (non-existent port) ──────────────────────────────────────────

@test "portman on unused port shows nothing running" {
  run bash "$PORTMAN" 59999
  # Should exit 0 but report nothing found
  [[ "$output" == *"Nothing"* ]] || [[ "$output" == *"nothing"* ]] || [[ "$output" == *"No process"* ]] || [[ "$output" == *"no process"* ]] || [[ "$output" == *"free"* ]]
}

# ─── Invalid port ─────────────────────────────────────────────────────────────

@test "portman with non-numeric port shows error" {
  run bash "$PORTMAN" abc
  [ "$status" -eq 1 ]
}

@test "portman kill with non-numeric port shows error" {
  run bash "$PORTMAN" kill abc
  [ "$status" -eq 1 ]
}

# ─── History ──────────────────────────────────────────────────────────────────

@test "portman history exits 0" {
  run bash "$PORTMAN" history
  [ "$status" -eq 0 ]
}

@test "portman history with no entries shows empty message" {
  run bash "$PORTMAN" history
  [[ "$output" == *"No"* ]] || [[ "$output" == *"empty"* ]] || [[ "$output" == *"history"* ]]
}

# ─── Kill on unused port ─────────────────────────────────────────────────────

@test "portman kill on unused port reports nothing" {
  run bash "$PORTMAN" kill 59998
  [[ "$output" == *"Nothing"* ]] || [[ "$output" == *"nothing"* ]] || [[ "$output" == *"No process"* ]] || [[ "$output" == *"no process"* ]] || [[ "$output" == *"free"* ]]
}
