# IPGen Command Line Tool

A command line tool for generating unique and reproducible IP addresses based on the [IPGen Spec].

## Installing

This tool relies on our [Rust library] to generate IP addresses. You will need `gcc` and `cargo` in your path.
With those two installed, run:-

```bash
cargo install ipgen-cli
```

This will install the `ipgen` command to `~/.cargo/bin` by default. Add it to your path. For example, if using
bash:-
```bash
export PATH="~/.cargo/bin:$PATH"
```

## Using

To generate an IP address you need the network address you are going to use in CIDR format (eg. fd9d:bb35:94bf::/48
or 10.0.0.0/8) and an abitrary identifier of the thing you are generating the IP address for. The identifier must be unique
within the subnet it will be running.

The general command for generating an IP address is:-
```bash
ipgen --network <NETWORK> <NAME>
```

Run `ipgen --help` for specific instructions.

### Examples

```bash
# Generate an IPv6 address for the first instance of Cassandra
$ ipgen --network fd9d:bb35:94bf::/48 cassandra.1
fd9d:bb35:94bf:c38a:ee1:c75d:8df3:c909

# Generate an IPv4 address for Postgresql on a host named host1
$ ipgen --network 10.0.0.0/8 postgresql.host1
10.102.194.34

# Generate an IPv6 subnet ID for Consul
$ ipgen consul
1211
```

[Rust library]: https://github.com/ipgen/rust
[IPGen Spec]: https://github.com/ipgen/spec
