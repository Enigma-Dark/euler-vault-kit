# Euler Vault Kit

The Euler Vault Kit is a system for constructing credit vaults. Credit vaults are ERC-4626 vaults with added borrowing functionality. Unlike typical ERC-4626 vaults which earn yield by actively investing deposited funds, credit vaults are passive lending pools. See the [whitepaper](https://docs.euler.finance/euler-vault-kit-white-paper/) for more details.

## Install

To install Euler Vault Kit in a [Foundry](https://github.com/foundry-rs/foundry) project:

```sh
forge install euler-xyz/euler-vault-kit
```

## Usage

To install Foundry:

```sh
curl -L https://foundry.paradigm.xyz | bash
```

This will download foundryup. To start Foundry, run:

```sh
foundryup
```

To clone the repo:

```sh
git clone https://github.com/euler-xyz/euler-vault-kit.git && cd euler-vault-kit
```

## Testing

### in `default` mode

To run the tests in a `default` mode:

```sh
forge test
```

### in `coverage` mode

```sh
./test/scripts/coverage.sh
```

## Invariant Testing Suite

This project has been set up with a suite of tests that check for specific invariants and properties for the evk, implemented by [vnmrtz.eth](https://twitter.com/vn_martinez_) from [Enigma Dark](https://www.enigmadark.com/). These tests are located in the `test/invariants` directory. They are written in Solidity and are designed to be run with the [echidna](https://github.com/crytic/echidna) fuzzing tool.

Installation and usage of these tools is outside the scope of this README, but you can find more information in the respective repositories:
- [Echidna Installation](https://github.com/crytic/echidna)

To run invariant tests with Echidna:

```sh
./test/scripts/echidna.sh  
```

To run assert tests with Echidna:

```sh
./test/scripts/echidna-assert.sh  
```

## Safety

This software is **experimental** and is provided "as is" and "as available".

**No warranties are provided** and **no liability will be accepted for any loss** incurred through the use of this codebase.

Always include thorough tests when using the Euler Vault Kit to ensure it interacts correctly with your code.

The Euler Vault Kit is currently undergoing security audits and should not be used in production.

## Known limitations

Refer to the [whitepaper](https://docs.euler.finance/euler-vault-kit-white-paper/) for a list of known limitations and security considerations.

## License

(c) 2024 Euler Labs Ltd.

The Euler Vault Kit code is licensed under GPL-2.0 or later except for the files in `src/EVault/modules/`, which are licensed under Business Source License 1.1 (see the file `LICENSE`). These files will be automatically re-licensed under GPL-2.0 or later on April 24th, 2029.
