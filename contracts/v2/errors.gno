package v2

import "errors"

var (
	ErrInvalidTokenId              = errors.New("invalid token id")
	ErrInvalidAddress              = errors.New("invalid address")
	ErrTokenIdNotHasApproved       = errors.New("token id not approved for anyone")
	ErrApprovalToCurrentOwner      = errors.New("approval to current owner")
	ErrCallerIsNotOwner            = errors.New("caller is not token owner")
	ErrCallerNotApprovedForAll     = errors.New("caller is not approved for all")
	ErrCannotTransferToSelf        = errors.New("cannot send transfer to self")
	ErrTransferFromIncorrectOwner  = errors.New("transfer from incorrect owner")
	ErrTransferToNonGRC721Receiver = errors.New("transfer to non GRC721Receiver implementer")
	ErrCallerIsNotOwnerOrApproved  = errors.New("caller is not token owner or approved")
	ErrTokenIdAlreadyExists        = errors.New("token id already exists")

	ErrPreviousRealmPkgPathMismatch = errors.New("previous realm package path mismatch")
	ErrRestrictedAccess             = errors.New("restricted access")
	ErrIsNotTerminated              = errors.New("this path is not terminated")
	ErrIsTerminated      	 		= errors.New("this path is terminated")
)
