package v1

import (
	"fmt"
	"std"
	"testing"
)

func TestVariables(t *testing.T) {
	admin := std.OriginCaller()
	previousRealmPkgPath := "gno.land/r/test/v2"

	t.Run("TestVariables", func(t *testing.T) {
		expect := "previous realm package path mismatch"
		defer func() {
			if r := recover(); r != nil && fmt.Sprintf("%v", r) != expect {
				t.Errorf("recovered from panic: %v", r)
			}
		}()

		testing.SetOriginCaller(admin)

		SetPreviousRealmPkgPath(previousRealmPkgPath)
	
		GetRefs()
	})
}

