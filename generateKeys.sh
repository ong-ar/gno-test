#!/usr/bin/expect

# gnokey check or delete

set ADMIN "admin" # g17nu20ft4gw9mfwpvx7563sl5h566e6kdpdqx3c
set TEST1 "test1" # g1mkxzwk5j4a5u2v20cjhavshmlm6te6waczjj26
set TEST2 "test2" # g1qenwsanlggg9hwq045xpnkumm9cylkdxje2mc8
set TEST3 "test3" # g149w86mvdw8ceek5namf88fc0h4tuppa76gctt0

set MNEMONIC "brief project paper calm song jump anger scorpion swear grain beach visual grocery puppy torch timber tank attract radar soup giraffe grit post crumble"

spawn gnokey delete $ADMIN

expect {
    "Key $ADMIN not found" {
        send "\r"
    }
    "DANGER - enter password to permanently delete key:" {
        send "\r"
    }
    eof
}

expect eof

spawn gnokey delete $TEST1

expect {
    "Key $TEST1 not found" {
        send "\r"
    }
    "DANGER - enter password to permanently delete key:" {
        send "\r"
    }
    eof
}

expect eof

spawn gnokey delete $TEST2

expect {
    "Key $TEST2 not found" {
        send "\r"
    }
    "DANGER - enter password to permanently delete key:" {
        send "\r"
    }
    eof
}

expect eof

spawn gnokey delete $TEST3

expect {
    "Key $TEST3 not found" {
        send "\r"
    }
    "DANGER - enter password to permanently delete key:" {
        send "\r"
    }
    eof
}

expect eof


# gnokey add

spawn gnokey add $ADMIN -recover -index 0

expect "Enter a passphrase to encrypt your key to disk:" {
    send "\r"
}

expect "Repeat the passphrase:" {
    send "\r"
}

expect "Enter your bip39 mnemonic" {
    send "$MNEMONIC\r"
}

expect eof


spawn gnokey add $TEST1 -recover -index 1

expect "Enter a passphrase to encrypt your key to disk:" {
    send "\r"
}

expect "Repeat the passphrase:" {
    send "\r"
}

expect "Enter your bip39 mnemonic" {
    send "$MNEMONIC\r"
}

expect eof

spawn gnokey add $TEST2 -recover -index 2

expect "Enter a passphrase to encrypt your key to disk:" {
    send "\r"
}

expect "Repeat the passphrase:" {
    send "\r"
}

expect "Enter your bip39 mnemonic" {
    send "$MNEMONIC\r"
}

expect eof

spawn gnokey add $TEST3 -recover -index 3

expect "Enter a passphrase to encrypt your key to disk:" {
    send "\r"
}

expect "Repeat the passphrase:" {
    send "\r"
}

expect "Enter your bip39 mnemonic" {
    send "$MNEMONIC\r"
}

expect eof

