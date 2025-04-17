package v2

import (
	"std"
)

func isValidAddress(addr std.Address) error {
	if !addr.IsValid() {
		return ErrInvalidAddress
	}
	return nil
}

func assertIsAdmin() {
	caller := std.OriginCaller()
	if admin != caller {
		panic(ErrRestrictedAccess)
	}
}

func assertIsTerminated() {
	if isTerminated {
		panic(ErrIsTerminated)
	}
}
