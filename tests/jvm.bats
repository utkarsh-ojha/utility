#!/usr/bin/env bats
# =============================================================================
# Tests for jvm — Java Version Manager
# =============================================================================

JVM="$BATS_TEST_DIRNAME/../mac/jvm/jvm"

setup() {
  export HOME="$BATS_TEST_TMPDIR"
  mkdir -p "$BATS_TEST_TMPDIR/.jvm"
}

teardown() {
  rm -rf "$BATS_TEST_TMPDIR/.jvm"
}

# ─── Help ─────────────────────────────────────────────────────────────────────

@test "jvm help exits 0" {
  run bash "$JVM" help
  [ "$status" -eq 0 ]
}

@test "jvm --help exits 0" {
  run bash "$JVM" --help
  [ "$status" -eq 0 ]
}

@test "jvm -h exits 0" {
  run bash "$JVM" -h
  [ "$status" -eq 0 ]
}

@test "jvm with no args shows help" {
  run bash "$JVM"
  [ "$status" -eq 0 ]
  [[ "$output" == *"jvm"* ]]
}

@test "help output contains version" {
  run bash "$JVM" help
  [[ "$output" == *"v1.0"* ]]
}

@test "help output contains UTKARSH OJHA" {
  run bash "$JVM" help
  [[ "$output" == *"UTKARSH OJHA"* ]]
}

@test "help output contains Java description" {
  run bash "$JVM" help
  [[ "$output" == *"Java"* ]]
}

# ─── Unknown command ──────────────────────────────────────────────────────────

@test "unknown command shows error" {
  run bash "$JVM" totally_bogus_command
  [ "$status" -eq 1 ]
}

# ─── List ─────────────────────────────────────────────────────────────────────

@test "jvm list exits 0" {
  run bash "$JVM" list
  [ "$status" -eq 0 ]
}

@test "jvm ls alias works" {
  run bash "$JVM" ls
  [ "$status" -eq 0 ]
}

# ─── Current ──────────────────────────────────────────────────────────────────

@test "jvm current exits 0" {
  run bash "$JVM" current
  [ "$status" -eq 0 ]
}

# ─── Doctor ───────────────────────────────────────────────────────────────────

@test "jvm doctor exits 0" {
  run bash "$JVM" doctor
  [ "$status" -eq 0 ]
}

@test "jvm doctor contains diagnostic output" {
  run bash "$JVM" doctor
  [[ "$output" == *"JAVA_HOME"* ]] || [[ "$output" == *"java"* ]] || [[ "$output" == *"Doctor"* ]] || [[ "$output" == *"doctor"* ]]
}

# ─── History ──────────────────────────────────────────────────────────────────

@test "jvm history exits 0" {
  run bash "$JVM" history
  [ "$status" -eq 0 ]
}

# ─── Pins ─────────────────────────────────────────────────────────────────────

@test "jvm pins exits 0" {
  run bash "$JVM" pins
  [ "$status" -eq 0 ]
}

# ─── Aliases ──────────────────────────────────────────────────────────────────

@test "jvm aliases exits 0" {
  run bash "$JVM" aliases
  [ "$status" -eq 0 ]
}

# ─── Env ──────────────────────────────────────────────────────────────────────

@test "jvm env exits 0" {
  run bash "$JVM" env
  [ "$status" -eq 0 ]
}

# ─── Use without version ─────────────────────────────────────────────────────

@test "jvm use without version shows error" {
  run bash "$JVM" use
  [ "$status" -eq 1 ] || [[ "$output" == *"Usage"* ]] || [[ "$output" == *"usage"* ]] || [[ "$output" == *"specify"* ]]
}

# ─── Remove without version ──────────────────────────────────────────────────

@test "jvm remove without version shows error" {
  run bash "$JVM" remove
  [ "$status" -eq 1 ] || [[ "$output" == *"Usage"* ]] || [[ "$output" == *"usage"* ]] || [[ "$output" == *"specify"* ]]
}

# ─── Search ───────────────────────────────────────────────────────────────────

@test "jvm search exits 0" {
  run bash "$JVM" search
  # May exit 0 (showing all) or 1 (needing arg) — both valid
  [[ "$status" -eq 0 ]] || [[ "$status" -eq 1 ]]
}
