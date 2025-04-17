#!/bin/bash

CHAIN_ID="dev"

ADMIN="g17nu20ft4gw9mfwpvx7563sl5h566e6kdpdqx3c"
TEST1="g1mkxzwk5j4a5u2v20cjhavshmlm6te6waczjj26"
TEST2="g1qenwsanlggg9hwq045xpnkumm9cylkdxje2mc8"
TEST3="g149w86mvdw8ceek5namf88fc0h4tuppa76gctt0"

V1_CONTRACT_PATH="./contracts/v1"
V2_CONTRACT_PATH="./contracts/v2"

V1_PACKAGE_PATH="gno.land/r/test/v1"
V2_PACKAGE_PATH="gno.land/r/test/v2"

TEST_PATH="./tests"

FAIL_COUNT=0

test_maketx() {
  local case_name="$1"
  local cmd="$2"
  local key="$3"
  local is_force_fail="$5"

  local case_form="🚀 \033[1m=== $case_name ===\033[0m"
  echo -e "$case_form 🚧"

  output=$(eval "$cmd -broadcast -insecure-password-stdin $key" <<< "" 2>&1)

  if echo "$output" | grep -qF "$4"; then
    if [ "$is_force_fail" == "true" ]; then
      echo "$output" | grep "Data:" || echo "$output" | grep "Error:"
    else
      echo "$output" | grep "TX HASH:"
    fi
    echo -e "$case_form ✅ PASS"
    echo ""
  else
    echo "$output" | grep "Data:" || echo "$output" | grep "Error:"
    echo -e "$case_form ❌ FAIL"
    echo ""
    ((FAIL_COUNT++))
  fi
}

test_query() {
  local case_name="$1"
  local cmd="$2"

  local case_form="🚀 \033[1m=== $case_name ===\033[0m"
  echo -e "$case_form 🚧"

  output=$(eval "$cmd" 2>&1)

  if echo "$output" | grep -qF "$3"; then
    echo "$output" | grep "data: "
    echo -e "$case_form ✅ PASS"
    echo ""
  else
    echo "$output" | grep "Data:" || echo "$output" | grep "data:"
    echo -e "$case_form ❌ FAIL"
    echo ""
    ((FAIL_COUNT++))
  fi
}

source ${TEST_PATH}/v1.sh
source ${TEST_PATH}/v2.sh
