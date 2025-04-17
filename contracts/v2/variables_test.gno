package v2

import (
	"testing"
)

func init() {
	println("init")
}

func TestVariables(t *testing.T) {
	t.Run("TestVariables", func(t *testing.T) {
		defer func() {
			if r := recover(); r != nil {
				t.Errorf("recovered from panic: %v", r)
			}
		}()
	})
}

