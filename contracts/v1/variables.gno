package v1

import (
	"std"

	"gno.land/p/demo/avl"
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
	name = "TestNFT"
	symbol = "TNFT"
	owners = avl.Tree{}
	balances = avl.Tree{}
	tokenApprovals = avl.Tree{}
	tokenURIs = avl.Tree{}
	operatorApprovals = avl.Tree{}

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