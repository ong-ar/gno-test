package v2

import (
	"std"
	"strconv"

	"gno.land/p/demo/ufmt"
)

// external methods

// Getters

func Name() string       { return name }
func Symbol() string     { return symbol }
func TokenCount() uint64 { return uint64(owners.Size()) }

func BalanceOf(user std.Address) uint64 {
	assertIsTerminated()

	balance, err := iBalanceOf(user)
	if err != nil {
		panic(err)
	}

	return balance
}

func OwnerOf(tid string) std.Address {
	assertIsTerminated()

	owner, err := iOwnerOf(tid)
	if err != nil {
		panic(err)
	}

	return owner
}


func IsApprovedForAll(owner, user std.Address) bool {
	assertIsTerminated()

	return iIsApprovedForAll(owner, user)
}

func GetApproved(tid string) std.Address {
	assertIsTerminated()

	addr, err := iGetApproved(tid)
	if err != nil {
		panic(err)
	}

	return addr
}

// TokenIdsOf returns all token ids of the input address
func TokenIdsOf(user std.Address) []string {
	assertIsTerminated()

	ids := make([]string, 0)
	owners.Iterate("", "", func(key string, value any) bool {
		if value == user {
			ids = append(ids, key)
		}
		return false
	})
	return ids
}

// Setters
func Approve(user std.Address, tid string) {
	assertIsTerminated()

	err := iApprove(user, tid)
	if err != nil {
		panic(err)
	}
}

func SetApprovalForAll(user std.Address, approved bool) {
	assertIsTerminated()

	err := iSetApprovalForAll(user, approved)
	if err != nil {
		panic(err)
	}
}

func TransferFrom(from, to std.Address, tid string) {
	assertIsTerminated()

	err := iTransferFrom(from, to, tid)
	if err != nil {
		panic(err)
	}
}

// Admin
func Mint(to std.Address, tid string) {
	assertIsTerminated()

	assertIsAdmin()
	err := iMint(to, tid)
	if err != nil {
		panic(err)
	}
}

func Burn(tid string) {
	assertIsTerminated()

	assertIsAdmin()
	err := iBurn(tid)
	if err != nil {
		panic(err)
	}
}

// Render
func Render(path string) string {
	switch {
	case isTerminated:
		return "this path is terminated (current path: " + nextPkgPath + ")\n"
	case path == "":
		return iRenderHome()
	default:
		return "404\n"
	}
}

// internal methods

// BalanceOf returns balance of input address
func iBalanceOf(addr std.Address) (uint64, error) {
	if err := isValidAddress(addr); err != nil {
		return 0, err
	}

	balance, found := balances.Get(addr.String())
	if !found {
		return 0, nil
	}

	return balance.(uint64), nil
}

// OwnerOf returns owner of input token id
func iOwnerOf(tid string) (std.Address, error) {
	owner, found := owners.Get(string(tid))
	if !found {
		return "", ErrInvalidTokenId
	}

	return owner.(std.Address), nil
}

// TokenURI returns the URI of input token id
func iTokenURI(tid string) (string, error) {
	uri, found := tokenURIs.Get(string(tid))
	if !found {
		return "", ErrInvalidTokenId
	}

	return uri.(string), nil
}

func iSetTokenURI(tid string, tURI string) (bool, error) {
	// check for invalid string
	if !exists(tid) {
		return false, ErrInvalidTokenId
	}

	// check for the right owner
	owner, err := iOwnerOf(tid)
	if err != nil {
		return false, err
	}
	caller := std.PreviousRealm().Address()
	if caller != owner {
		return false, ErrCallerIsNotOwner
	}
	tokenURIs.Set(string(tid), string(tURI))
	return true, nil
}

// IsApprovedForAll returns true if operator is approved for all by the owner.
// Otherwise, returns false
func iIsApprovedForAll(owner, operator std.Address) bool {
	key := owner.String() + ":" + operator.String()
	_, found := operatorApprovals.Get(key)
	if !found {
		return false
	}

	return true
}

// Approve approves the input address for particular token
func iApprove(to std.Address, tid string) error {
	if err := isValidAddress(to); err != nil {
		return err
	}

	owner, err := iOwnerOf(tid)
	if err != nil {
		return err
	}
	if owner == to {
		return ErrApprovalToCurrentOwner
	}

	caller := std.PreviousRealm().Address()
	if caller != owner && !iIsApprovedForAll(owner, caller) {
		return ErrCallerIsNotOwnerOrApproved
	}

	tokenApprovals.Set(string(tid), to.String())
	std.Emit(
		ApprovalEvent,
		"owner", string(owner),
		"to", string(to),
		"tokenId", string(tid),
	)

	return nil
}

// GetApproved return the approved address for token
func iGetApproved(tid string) (std.Address, error) {
	addr, found := tokenApprovals.Get(string(tid))
	if !found {
		return zeroAddress, ErrTokenIdNotHasApproved
	}

	return std.Address(addr.(string)), nil
}

// SetApprovalForAll can approve the operator to operate on all tokens
func iSetApprovalForAll(operator std.Address, approved bool) error {
	if err := isValidAddress(operator); err != nil {
		return ErrInvalidAddress
	}

	caller := std.PreviousRealm().Address()
	return setApprovalForAll(caller, operator, approved)
}

// Safely transfers `tokenId` token from `from` to `to`, checking that
// contract recipients are aware of the GRC721 protocol to prevent
// tokens from being forever locked.
func iSafeTransferFrom(from, to std.Address, tid string) error {
	caller := std.PreviousRealm().Address()
	if !isApprovedOrOwner(caller, tid) {
		return ErrCallerIsNotOwnerOrApproved
	}

	err := transfer(from, to, tid)
	if err != nil {
		return err
	}

	// if !checkOnGRC721Received(from, to, tid) {
	// 	return ErrTransferToNonGRC721Receiver
	// }

	return nil
}

// Transfers `tokenId` token from `from` to `to`.
func iTransferFrom(from, to std.Address, tid string) error {
	caller := std.PreviousRealm().Address()
	if !isApprovedOrOwner(caller, tid) {
		return ErrCallerIsNotOwnerOrApproved
	}

	err := transfer(from, to, tid)
	if err != nil {
		return err
	}

	return nil
}

// Mints `tokenId` and transfers it to `to`.
func iMint(to std.Address, tid string) error {
	return mint(to, tid)
}

// Mints `tokenId` and transfers it to `to`. Also checks that
// contract recipients are using GRC721 protocol
func iSafeMint(to std.Address, tid string) error {
	err := mint(to, tid)
	if err != nil {
		return err
	}

	// if !checkOnGRC721Received(zeroAddress, to, tid) {
	// 	return ErrTransferToNonGRC721Receiver
	// }

	return nil
}

func iBurn(tid string) error {
	owner, err := iOwnerOf(tid)
	if err != nil {
		return err
	}

	// beforeTokenTransfer(owner, zeroAddress, tid, 1)

	tokenApprovals.Remove(string(tid))
	balance, err := iBalanceOf(owner)
	if err != nil {
		return err
	}
	balance -= 1
	balances.Set(owner.String(), balance)
	owners.Remove(string(tid))

	std.Emit(
		BurnEvent,
		"from", string(owner),
		"tokenId", string(tid),
	)

	// afterTokenTransfer(owner, zeroAddress, tid, 1)

	return nil
}

/* Helper methods */

// Helper for SetApprovalForAll()
func setApprovalForAll(owner, operator std.Address, approved bool) error {
	if owner == operator {
		return ErrApprovalToCurrentOwner
	}

	key := owner.String() + ":" + operator.String()
	operatorApprovals.Set(key, approved)

	std.Emit(
		ApprovalForAllEvent,
		"owner", string(owner),
		"to", string(operator),
		"approved", strconv.FormatBool(approved),
	)

	return nil
}

// Helper for TransferFrom() and SafeTransferFrom()
func transfer(from, to std.Address, tid string) error {
	if err := isValidAddress(from); err != nil {
		return ErrInvalidAddress
	}
	if err := isValidAddress(to); err != nil {
		return ErrInvalidAddress
	}

	if from == to {
		return ErrCannotTransferToSelf
	}

	owner, err := iOwnerOf(tid)
	if err != nil {
		return err
	}
	if owner != from {
		return ErrTransferFromIncorrectOwner
	}

	// beforeTokenTransfer(from, to, tid, 1)

	// Check that tokenId was not transferred by `beforeTokenTransfer`
	owner, err = iOwnerOf(tid)
	if err != nil {
		return err
	}
	if owner != from {
		return ErrTransferFromIncorrectOwner
	}

	tokenApprovals.Remove(string(tid))
	fromBalance, err := iBalanceOf(from)
	if err != nil {
		return err
	}
	toBalance, err := iBalanceOf(to)
	if err != nil {
		return err
	}
	fromBalance -= 1
	toBalance += 1
	balances.Set(from.String(), fromBalance)
	balances.Set(to.String(), toBalance)
	owners.Set(string(tid), to)

	std.Emit(
		TransferEvent,
		"from", string(from),
		"to", string(to),
		"tokenId", string(tid),
	)

	// afterTokenTransfer(from, to, tid, 1)

	return nil
}

// Helper for Mint() and SafeMint()
func mint(to std.Address, tid string) error {
	if err := isValidAddress(to); err != nil {
		return err
	}

	if exists(tid) {
		return ErrTokenIdAlreadyExists
	}

	// beforeTokenTransfer(zeroAddress, to, tid, 1)

	// Check that tokenId was not minted by `beforeTokenTransfer`
	if exists(tid) {
		return ErrTokenIdAlreadyExists
	}

	toBalance, err := iBalanceOf(to)
	if err != nil {
		return err
	}
	toBalance += 1
	balances.Set(to.String(), toBalance)
	owners.Set(string(tid), to)

	std.Emit(
		MintEvent,
		"to", string(to),
		"tokenId", string(tid),
	)

	// afterTokenTransfer(zeroAddress, to, tid, 1)

	return nil
}

func isApprovedOrOwner(addr std.Address, tid string) bool {
	owner, found := owners.Get(string(tid))
	if !found {
		return false
	}

	if addr == owner.(std.Address) || iIsApprovedForAll(owner.(std.Address), addr) {
		return true
	}

	approved, err := iGetApproved(tid)
	if err != nil {
		return false
	}

	return approved == addr
}

// Checks if token id already exists
func exists(tid string) bool {
	_, found := owners.Get(string(tid))
	return found
}

// func beforeTokenTransfer(from, to std.Address, firstTokenId string, batchSize uint64) {
// 	// TODO: Implementation
// }

// func afterTokenTransfer(from, to std.Address, firstTokenId string, batchSize uint64) {
// 	// TODO: Implementation
// }

// func checkOnGRC721Received(from, to std.Address, tid string) bool {
// 	// TODO: Implementation
// 	return true
// }

func iRenderHome() (str string) {
	str += ufmt.Sprintf("# %s ($%s)\n\n", name, symbol)
	str += ufmt.Sprintf("* **Total supply**: %d\n", TokenCount())
	str += ufmt.Sprintf("* **Known accounts**: %d\n", balances.Size())

	return
}
