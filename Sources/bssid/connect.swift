import Guaka
import Foundation
import CoreWLAN

var connectCommand = Command(
        usage: "connect",
        configuration: configuration,
        run: execute
)

private func configuration(command: Command) {
    command.add(flags: [
        // Add your flags here
    ])
    // Other configurations
    command.shortMessage = "connect to a WiFi network with given BSSID"
    command.example = "bssid connect 12:ab:cd:34:ef:56"
}

private func execute(flags: Flags, args: [String]) {
    // Execute code here

    if (args.count != 1) {
        print("require a BSSID")
        return
    }
    let bssidName = args[0]

    let wifiClient = CWWiFiClient()
    guard let interface = wifiClient.interface(), interface.powerOn() else {
        print("Cannot create interface or interface is not turned on")
        return
    }

    guard let networks = try? scanNetworks(interface) else {
        return
    }

    for network in networks {
        if network.bssid ?? "" == bssidName {
            print("Input WiFi password")
            let password = String(cString: getpass(""))
            do {
                try interface.associate(to: network, password: password)
            } catch {
                print(String(format: "Failed connecting to %@, bssid %@"),
                        network.ssid ?? "", network.bssid ?? "")
            }
        }
    }
}
