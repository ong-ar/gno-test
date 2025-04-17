package v1

import (
	"std"

	"gno.land/p/demo/grc/grc721"
)

func isValidAddress(addr std.Address) error {
	if !addr.IsValid() {
		return grc721.ErrInvalidAddress
	}
	return nil
}

func assertIsAdmin() {
	caller := std.OriginCaller()
	if admin != caller {
		panic("restricted access")
	}
}
