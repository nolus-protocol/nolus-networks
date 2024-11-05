This is the descriptor of the network topology and currencies of interest for the Nolus AMM protocol.

The network topology is represented as a collection of networks and the ICS-20 transfer channels that connect them.  
Some networks may have DEX services available.
Each DEX is uniquely named and should have a type supported by Nolus.  
The supported types are `osmosis`, `astroport_test`, and `astroport_main`.

On a given network, each currency is identified by its 'ticker'.
A currency with ticker `NLS` on a network `NOLUS` is required.  
The `NOLUS` network description should not contain other currencies.
They are defined in the `currencies` object of each entry in the `networks` object.

A currency is either native or an IBC one on a given network.
In the former case it is described with name, symbol and number of decimal digits.
In the latter case, it points to the "burning" currency residing at a network
that is at one hop distance.

The `name` is a human-readable description of the currency.  
The `symbol` is the base denomination of the currency at its native chain.  
The `decimal_digits` value represents the number of decimal digits this denomination has.
For example, `6` for `OSMO` means `10^6` units of its base denomination, `uosmo`, are equal to 1 `OSMO`.

The `icon` is an optional currency attribute that provides a visual representation of the currency.
In other workds, if there is no icon attribute of an IBC currency, then the icon is derived from the network and currency it points to.
This might be applied multiple times traversing the IBC path toward its native network.

The currency's symbol at a given network depends on it's origin.

For native currencies, it's equal to the value of the `symbol` field. It should be noted that in some instances the symbol can take other forms, including `factory/<BECH32 address>/milkutia`.

For non-native currencies, minted via an IBC transfer, the symbol is generated.  
The symbol of formed like follows: `"ibc/" + digest`, where `digest` is the output of the SHA2-256 ("SHA2") hashing algorithm.  
The input to the SHA2 algorithm is the concatenation of each channel ID prefixed by `transfer/` and suffixed by `/` (e.g. `transfer/channel-123`), and finally suffixed with the currency symbol on it's origin network.  
Example path used as input to the SHA2 algorithm is as follows: `transfer/channel-1/transfer/channel-2/unls`.  
More information is available [here](https://github.com/cosmos/ibc-go/blob/c86d27fc280cfb342a9e4689b381e5823441b694/modules/apps/transfer/types/trace.go#L19).
