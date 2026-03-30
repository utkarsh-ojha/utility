#!/usr/bin/env bats
# =============================================================================
# Tests for goto — Directory Bookmark Engine
# =============================================================================

GOTO="$BATS_TEST_DIRNAME/../mac/goto/goto"

setup() {
  export HOME="$BATS_TEST_TMPDIR"
  export GOTO_REGISTRY="$BATS_TEST_TMPDIR/.goto_registry"
  # Create a temp directory structure for bookmarks
  mkdir -p "$BATS_TEST_TMPDIR/projects/myapp/src"
  mkdir -p "$BATS_TEST_TMPDIR/projects/backend/api"
  # The script uses $HOME/.goto_registry — ensure clean state
  rm -f "$BATS_TEST_TMPDIR/.goto_registry"
  rm -f "$BATS_TEST_TMPDIR/.goto_history"
  touch "$BATS_TEST_TMPDIR/.goto_registry"
}

teardown() {
  rm -f "$BATS_TEST_TMPDIR/.goto_registry"
  rm -f "$BATS_TEST_TMPDIR/.goto_history"
}

# ─── Help ─────────────────────────────────────────────────────────────────────

@test "goto help exits 0" {
  run bash "$GOTO" help
  [ "$status" -eq 0 ]
}

@test "goto --help exits 0" {
  run bash "$GOTO" --help
  [ "$status" -eq 0 ]
}

@test "help output contains version" {
  run bash "$GOTO" help
  [[ "$output" == *"goto v"* ]]
}

@test "help output contains UTKARSH OJHA" {
  run bash "$GOTO" help
  [[ "$output" == *"UTKARSH OJHA"* ]]
}

@test "help output contains Directory Bookmark Engine" {
  run bash "$GOTO" help
  [[ "$output" == *"Directory Bookmark Engine"* ]]
}

@test "help lists history command" {
  run bash "$GOTO" help
  [[ "$output" == *"history"* ]]
}

@test "help lists export command" {
  run bash "$GOTO" help
  [[ "$output" == *"export"* ]]
}

@test "help lists import command" {
  run bash "$GOTO" help
  [[ "$output" == *"import"* ]]
}

# ─── Add ──────────────────────────────────────────────────────────────────────

@test "goto add bookmarks current directory" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  run bash "$GOTO" add myapp
  [ "$status" -eq 0 ]
  [[ "$output" == *"Bookmarked"* ]]
  # Verify registry has the entry
  grep -q "^myapp|" "$BATS_TEST_TMPDIR/.goto_registry"
}

@test "goto add with invalid chars fails" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  run bash "$GOTO" add "my app"
  [ "$status" -eq 1 ]
  [[ "$output" == *"Invalid"* ]]
}

@test "goto add allows dots and hyphens" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  run bash "$GOTO" add "my-app.v2"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Bookmarked"* ]]
}

@test "goto add duplicate same path is ok" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  run bash "$GOTO" add myapp
  [ "$status" -eq 0 ]
  # Adding same bookmark to same path again
  run bash "$GOTO" add myapp
  [ "$status" -eq 0 ]
  [[ "$output" == *"already points"* ]]
}

# ─── List ─────────────────────────────────────────────────────────────────────

@test "goto list with no bookmarks shows empty message" {
  run bash "$GOTO" list
  [ "$status" -eq 0 ]
  [[ "$output" == *"No bookmarks"* ]]
}

@test "goto list shows bookmarks after add" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  bash "$GOTO" add myapp > /dev/null 2>&1
  run bash "$GOTO" list
  [ "$status" -eq 0 ]
  [[ "$output" == *"myapp"* ]]
  [[ "$output" == *"1 bookmark"* ]]
}

@test "goto list detects dead bookmarks" {
  echo "deadbookmark|/nonexistent/path/that/doesnt/exist" >> "$BATS_TEST_TMPDIR/.goto_registry"
  run bash "$GOTO" list
  [ "$status" -eq 0 ]
  [[ "$output" == *"not found"* ]] || [[ "$output" == *"dead"* ]]
}

# ─── Jump ─────────────────────────────────────────────────────────────────────

@test "goto jump to valid bookmark outputs cd directive" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  bash "$GOTO" add myapp > /dev/null 2>&1
  run bash "$GOTO" myapp
  [ "$status" -eq 0 ]
  [[ "$output" == *"__goto_cd__:"* ]]
}

@test "goto jump with sub-path works" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  bash "$GOTO" add myapp > /dev/null 2>&1
  run bash "$GOTO" myapp/src
  [ "$status" -eq 0 ]
  [[ "$output" == *"__goto_cd__:"* ]]
  [[ "$output" == *"/src"* ]]
}

@test "goto jump to nonexistent bookmark fails" {
  run bash "$GOTO" nosuchbookmark
  [ "$status" -eq 1 ]
  [[ "$output" == *"not found"* ]]
}

@test "goto jump to nonexistent bookmark shows fuzzy suggestions" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  bash "$GOTO" add myapp > /dev/null 2>&1
  run bash "$GOTO" myap
  [ "$status" -eq 1 ]
  [[ "$output" == *"Did you mean"* ]]
}

# ─── Remove ──────────────────────────────────────────────────────────────────

@test "goto remove without name shows error" {
  run bash "$GOTO" remove
  [ "$status" -eq 1 ]
}

@test "goto remove nonexistent bookmark fails" {
  run bash "$GOTO" remove nothing
  [ "$status" -eq 1 ]
  [[ "$output" == *"not found"* ]]
}

@test "goto remove deletes a bookmark" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  bash "$GOTO" add myapp > /dev/null 2>&1
  run bash "$GOTO" remove myapp
  [ "$status" -eq 0 ]
  [[ "$output" == *"removed"* ]] || [[ "$output" == *"Removed"* ]]
  # Verify it's gone
  ! grep -q "^myapp|" "$BATS_TEST_TMPDIR/.goto_registry"
}

# ─── Clean ────────────────────────────────────────────────────────────────────

@test "goto clean on empty registry reports empty" {
  run bash "$GOTO" clean
  [ "$status" -eq 0 ]
  [[ "$output" == *"empty"* ]]
}

# ─── History ──────────────────────────────────────────────────────────────────

@test "goto history with no jumps shows empty" {
  run bash "$GOTO" history
  [ "$status" -eq 0 ]
  [[ "$output" == *"No jump history"* ]]
}

@test "goto history shows entries after jump" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  bash "$GOTO" add myapp > /dev/null 2>&1
  bash "$GOTO" myapp > /dev/null 2>&1
  run bash "$GOTO" history
  [ "$status" -eq 0 ]
  [[ "$output" == *"myapp"* ]]
}

# ─── Export ───────────────────────────────────────────────────────────────────

@test "goto export with no bookmarks fails" {
  run bash "$GOTO" export
  [ "$status" -eq 1 ]
}

@test "goto export outputs registry contents" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  bash "$GOTO" add myapp > /dev/null 2>&1
  run bash "$GOTO" export
  [ "$status" -eq 0 ]
  [[ "$output" == *"myapp|"* ]]
}

# ─── Import ──────────────────────────────────────────────────────────────────

@test "goto import without file shows error" {
  run bash "$GOTO" import
  [ "$status" -eq 1 ]
}

@test "goto import nonexistent file shows error" {
  run bash "$GOTO" import /nonexistent/file.txt
  [ "$status" -eq 1 ]
  [[ "$output" == *"not found"* ]] || [[ "$output" == *"File not found"* ]]
}

@test "goto import adds bookmarks from file" {
  local import_file="$BATS_TEST_TMPDIR/import.txt"
  echo "proj1|$BATS_TEST_TMPDIR/projects/myapp" > "$import_file"
  echo "proj2|$BATS_TEST_TMPDIR/projects/backend" >> "$import_file"
  run bash "$GOTO" import "$import_file"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Imported"* ]] || [[ "$output" == *"imported"* ]]
  grep -q "^proj1|" "$BATS_TEST_TMPDIR/.goto_registry"
  grep -q "^proj2|" "$BATS_TEST_TMPDIR/.goto_registry"
}

@test "goto import skips duplicates" {
  cd "$BATS_TEST_TMPDIR/projects/myapp"
  bash "$GOTO" add myapp > /dev/null 2>&1
  local import_file="$BATS_TEST_TMPDIR/import.txt"
  echo "myapp|/some/path" > "$import_file"
  run bash "$GOTO" import "$import_file"
  [ "$status" -eq 0 ]
  [[ "$output" == *"already exists"* ]] || [[ "$output" == *"Skipping"* ]]
}

@test "goto import rejects malformed entries" {
  local import_file="$BATS_TEST_TMPDIR/import.txt"
  echo "bad name|/some/path" > "$import_file"
  run bash "$GOTO" import "$import_file"
  [ "$status" -eq 0 ]
  [[ "$output" == *"malformed"* ]] || [[ "$output" == *"Malformed"* ]] || [[ "$output" == *"Skipping"* ]]
}
