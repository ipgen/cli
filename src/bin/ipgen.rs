use structopt::StructOpt;

/// Generates unique and reproducible IP addresses as per the IPGen Spec
/// (https://github.com/ipgen/spec)
#[derive(StructOpt, Debug)]
#[structopt(name = "IPGen")]
struct App {
    /// The name of the thing you are generating an IP address or subnet ID for
    #[structopt(name = "NAME")]
    name: String,

    /// IP network e.g. fd52:f6b0:3162::/48 or 10.0.0.0/8.
    /// If provided, this program will print an IP address, if not, a subnet ID
    /// will be printed instead.
    #[structopt(short, long, name = "NETWORK")]
    network: Option<String>,
}

fn run(app: App) -> ipgen::Result<()> {
    match app.network {
        Some(network) => {
            let ip_addr = ipgen::ip(&app.name, network.parse()?)?;
            println!("{}", ip_addr);
        }
        None => println!("{}", ipgen::subnet(&app.name)?),
    }
    Ok(())
}

fn main() {
    if let Err(error) = run(App::from_args()) {
        eprintln!("{}", error);
        std::process::exit(1);
    }
}
