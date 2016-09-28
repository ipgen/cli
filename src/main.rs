extern crate clap;
extern crate ipgen;

use clap::{Arg, App};
use std::process::exit;
use std::io::{self, Write};

fn main() {
    let matches = App::new("IPv6 Address Generator")
        .version(env!("CARGO_PKG_VERSION"))
        .about("Generates unique and reproducible IPv6 addresses")
        .arg(Arg::with_name("name")
            .help("The name of the thing you are generating an IP address or subnet ID for")
            .required(true)
            .value_name("NAME"))
        .arg(Arg::with_name("network")
            .long("network")
            .short("n")
            .help("IPv6 network eg fd52:f6b0:3162::/48. If network is not provided, the value \
                   returned will only be for a subnet ID.")
            .value_name("NETWORK"))
        .get_matches();
    let name = matches.value_of("name").expect("name is required");
    let network = match matches.value_of("network") {
        Some(n) => n,
        None => "",
    };
    if network.is_empty() {
        println!("{}", ipgen::subnet(name));
    } else {
        match ipgen::ip(name, network) {
            Ok(ip) => println!("{}", ip),
            Err(msg) => {
                match writeln!(&mut io::stderr(), "{}", msg) {
                    Ok(_) => {
                        // sucessfully printed error
                    }
                    Err(_) => println!("{}", msg),
                };
                exit(1);
            }
        };
    };
}
