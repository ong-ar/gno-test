#!/bin/bash

## v2 배포 테스트 (실패)
test_maketx "[v2] Deploying (from: admin) [fail]" \
 "
  gnokey maketx addpkg \
    -pkgpath '$V2_PACKAGE_PATH' \
    -pkgdir '$V2_CONTRACT_PATH' \
    -chainid '$CHAIN_ID' \
    -gas-fee 100000000ugnot \
    -gas-wanted 1000000000 \
 " \
 "$ADMIN" \
 "previous realm package path mismatch" \
 "true"

 ## 컨트랙트 소유자가 아닌 사람이 Mint 시도 (실패)
 test_maketx "[v1] SetNextPkgPath(v2_package_path) (from: admin)" \
 "
  gnokey maketx call \
    -pkgpath '$V1_PACKAGE_PATH' \
    -chainid '$CHAIN_ID' \
    -func 'SetNextPkgPath' \
    -args '$V2_PACKAGE_PATH' \
    -gas-fee 1000000ugnot \
    -gas-wanted 100000000 \
 " \
 "$ADMIN" \
 "OK!" \


 ## v2 배포 테스트
test_maketx "[v2] Deploying (from: admin)" \
 "
  gnokey maketx addpkg \
    -pkgpath '$V2_PACKAGE_PATH' \
    -pkgdir '$V2_CONTRACT_PATH' \
    -chainid '$CHAIN_ID' \
    -gas-fee 100000000ugnot \
    -gas-wanted 1000000000 \
 " \
 "$ADMIN" \
 "OK!" \

## TransferFrom(admin, test1, 1) (from: admin)
test_maketx "[v2] TransferFrom(admin, test1, 1) (from: admin)" \
 "
  gnokey maketx call \
    -pkgpath '$V2_PACKAGE_PATH' \
    -chainid '$CHAIN_ID' \
    -func 'TransferFrom' \
    -args '$ADMIN' \
    -args '$TEST1' \
    -args "1" \
    -gas-fee 1000000ugnot \
    -gas-wanted 100000000 \
 " \
 "$ADMIN" \
 "OK!"

## TransferFrom(test2, admin, 8) (from: admin)
test_maketx "[v2] TransferFrom(test2, admin, 8) (from: admin)" \
 "
  gnokey maketx call \
    -pkgpath '$V2_PACKAGE_PATH' \
    -chainid '$CHAIN_ID' \
    -func 'TransferFrom' \
    -args '$TEST2' \
    -args '$ADMIN' \
    -args "8" \
    -gas-fee 1000000ugnot \
    -gas-wanted 100000000 \
 " \
 "$ADMIN" \
 "OK!"

# ## admin 계정으로 Mint
# test_maketx "[v1] Mint(admin, 0) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Mint' \
#     -args '$ADMIN' \
#     -args "0" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

# ## admin 계정으로 Mint
# test_maketx "[v1] Mint(admin, 1) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Mint' \
#     -args '$ADMIN' \
#     -args "1" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

# ## admin 계정으로 Mint
# test_maketx "[v1] Mint(admin, 2) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Mint' \
#     -args '$ADMIN' \
#     -args "2" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

# ## admin 계정으로 Mint
# test_maketx "[v1] Mint(test1, 3) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Mint' \
#     -args '$TEST1' \
#     -args "3" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

# ## admin 계정으로 Mint
# test_maketx "[v1] Mint(test1, 4) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Mint' \
#     -args '$TEST1' \
#     -args "4" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

# ## admin 계정으로 Mint
# test_maketx "[v1] Mint(test1, 5) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Mint' \
#     -args '$TEST1' \
#     -args "5" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

# ## admin 계정으로 Mint
# test_maketx "[v1] Mint(test2, 6) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Mint' \
#     -args '$TEST2' \
#     -args "6" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"


# ## admin 계정으로 Mint
# test_maketx "[v1] Mint(test2, 7) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Mint' \
#     -args '$TEST2' \
#     -args "7" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

#  ## admin 계정으로 Mint
# test_maketx "[v1] Mint(test2, 8) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Mint' \
#     -args '$TEST2' \
#     -args "8" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

# ## TransferFrom(admin, test1, 0) (from: admin)
# test_maketx "[v1] TransferFrom(admin, test1, 0) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'TransferFrom' \
#     -args '$ADMIN' \
#     -args '$TEST1' \
#     -args "0" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

# ## TransferFrom(test1, test2, 3) (from: admin) (실패)
# test_maketx "[v1] TransferFrom(test1, test2, 3) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'TransferFrom' \
#     -args '$TEST1' \
#     -args '$TEST2' \
#     -args "3" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "caller is not token owner or approved" \
#  "true"

# ## Approve(admin, 3) (from: test1)
# test_maketx "[v1] Approve(admin, 3) (from: test1)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Approve' \
#     -args '$ADMIN' \
#     -args '3' \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$TEST1" \
#  "OK!"

# ## TransferFrom(test1, test2, 3) (from: admin)
# test_maketx "[v1] TransferFrom(test1, test2, 3) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'TransferFrom' \
#     -args '$TEST1' \
#     -args '$TEST2' \
#     -args "3" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

# ## SetApprovalForAll(admin, true) (from: test2)
# test_maketx "[v1] SetApprovalForAll(admin, true) (from: test2)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'SetApprovalForAll' \
#     -args '$ADMIN' \
#     -args true \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$TEST2" \
#  "OK!"

# ## TransferFrom(test2, admin, 6) (from: admin)
# test_maketx "[v1] TransferFrom(test2, admin, 6) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'TransferFrom' \
#     -args '$TEST2' \
#     -args '$ADMIN' \
#     -args "6" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

# ## TransferFrom(test2, admin, 6) (from: admin)
# test_maketx "[v1] TransferFrom(test2, admin, 7) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'TransferFrom' \
#     -args '$TEST2' \
#     -args '$ADMIN' \
#     -args "7" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

# ## Burn(7) (from: test1) (실패)
# test_maketx "[v1] Burn(7) (from: test1)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Burn' \
#     -args "7" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$TEST1" \
#  "restricted access"
#  "true"

# ## Burn(7) (from: admin)
# test_maketx "[v1] Burn(7) (from: admin)" \
#  "
#   gnokey maketx call \
#     -pkgpath '$V1_PACKAGE_PATH' \
#     -chainid '$CHAIN_ID' \
#     -func 'Burn' \
#     -args "7" \
#     -gas-fee 1000000ugnot \
#     -gas-wanted 100000000 \
#  " \
#  "$ADMIN" \
#  "OK!"

## TokenIdsOf(admin)
test_query "[v2] TokenIdsOf(admin)" \
 "gnokey query vm/qeval -data 'gno.land/r/test/v2.TokenIdsOf(\"$ADMIN\")'" \
 '(slice[("2" string),("6" string),("8" string)] []string)'

## TokenIdsOf(test1)
test_query "[v2] TokenIdsOf(test1)" \
 "gnokey query vm/qeval -data 'gno.land/r/test/v2.TokenIdsOf(\"$TEST1\")'" \
 '(slice[("0" string),("1" string),("4" string),("5" string)] []string)'

## TokenIdsOf(test2)
test_query "[v2] TokenIdsOf(test2)" \
 "gnokey query vm/qeval -data 'gno.land/r/test/v2.TokenIdsOf(\"$TEST2\")'" \
 '(slice[("3" string)] []string)'


if [ $FAIL_COUNT -eq 0 ]; then
  echo "[v1]👍 All tests passed!"
else
  echo "[v1]👎 $FAIL_COUNT tests failed."
fi

FAIL_COUNT=0