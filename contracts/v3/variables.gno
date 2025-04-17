package v2

import (
	"std"

	"gno.land/p/demo/avl"
	v1 "gno.land/r/test/v1"
)

const zeroAddress std.Address = ""

var (
	name                 string
	symbol               string
	owners               avl.Tree // tokenId -> OwnerAddress
	balances             avl.Tree // OwnerAddress -> TokenCount
	tokenApprovals       avl.Tree // TokenId -> ApprovedAddress
	tokenURIs            avl.Tree // TokenId -> URIs
	operatorApprovals    avl.Tree // "OwnerAddress:OperatorAddress" -> bool

	nextPkgPath          string
	admin			     std.Address
)

func init() {
	prevName, prevSymbol, prevOwners, prevBalances, prevTokenApprovals, prevTokenURIs, prevOperatorApprovals := v1.GetRefs()

	name = *prevName
	symbol = *prevSymbol
	owners = *prevOwners
	balances = *prevBalances
	tokenApprovals = *prevTokenApprovals
	tokenURIs = *prevTokenURIs
	operatorApprovals = *prevOperatorApprovals

	nextPkgPath = ""
	admin = std.OriginCaller()
}

// external methods
func GetRefs() (*string, *string, *avl.Tree, *avl.Tree, *avl.Tree, *avl.Tree, *avl.Tree) {
	pkgPath := std.PreviousRealm().PkgPath()

	if nextPkgPath == "" || pkgPath == "" || nextPkgPath != pkgPath {
		panic("previous realm package path mismatch")
	}
	
	assertIsAdmin()

	return &name, &symbol, &owners, &balances, &tokenApprovals, &tokenURIs, &operatorApprovals
}

func SetNextPkgPath(pkgPath string) {
	assertIsAdmin()

	nextPkgPath = pkgPath
}

func SetAdmin(addr std.Address) {
	assertIsAdmin()

	if !addr.IsValid() {
		panic("invalid address")
	}

	admin = addr
}