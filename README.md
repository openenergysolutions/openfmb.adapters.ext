# OpenFMB Adapters Extensions

This repo consists of a Dockerfile that is used to build an "Extension" for OpenFMB Adapter framework.  

## Objectives:

The objective is to enhance an existing OpenFMB Adapter Framework by extending its capabilities to support multiple protocols, regardless of the programming language used. This expansion will allow seamless integration with various systems and enable communication using different protocols.

One key aspect of this extension is the ability to leverage the existing OpenFMB Adapter Framework's functionalities, such as MQTT, NATS, DNP3, MODBUS, and more. These features provide robust communication channels and protocol-specific implementations that can be utilized by the newly added plugins or extensions.

By incorporating this extension mechanism, developers can write custom plugins or extensions in their preferred programming languages. This flexibility enables them to leverage their existing knowledge and expertise while expanding the framework's protocol support. Whether it's implementing a custom UDP datagram speaker, integrating with OCPP1.6, or storing telemetry data in databases, the extended framework provides the necessary tools and infrastructure.

The extended framework also promotes interoperability and compatibility across different systems and protocols. It allows seamless communication between components written in different programming languages, facilitating integration with a wide range of devices and platforms.

## Zenoh Bus

[Zenoh](https://zenoh.io/) bus is used as an `internal/inside-container` communication channel between the extension app and the [OpenFMB Adapter](https://openfmb.openenergysolutions.com/docs/adapter/) written by [OES](https://openenergysolutions.com/).

## How to Write UDP OpenFMB Adapter, an Extension for OpenFMB Adapter Framework

The goal here is to utilize the extension framework we have developed to establish communication with a fictitious smart plug device that speaks UDP. The extension framework allows for integration of UDP protocol adapter written in any programming languages, enabling efficient and flexible communication with the devices.

For sample code, refer to this [repo](https://github.com/openenergysolutions/openfmb.adapters.udp.git).  This sample code (UDP OpenFMB Adapter) is written in RUST programming language and takes advantage of an `inside-container` communication bus.  Upon receiving data from the fictitious smart plug device, the UDP OpenFMB Adapter shall publish `SwitchStatusProfile` with the plug's On/Off indication, and `SwitchReadingProfile` for voltage, current, and power measurement. The UDP OpenFMB Adapter also subscribes to `SwitchDiscreteControlProfile` and turn On/Off the smart plug accordingly.

## Build the Docker Image

Run the build script to build the Docker image:

```bash
./build.sh
```

## Launcher Configuration

Launcher is an app that acts as the entry point of the Docker image.  The following configuration is used by the Launcher:

```yaml
---
launcher:
  log_level: Debug
adapters: 
  - name: oes-plug
    type: oes-plug
    config: /adapters/udp-adapter.yaml
  - name: bridge-master
    type: pub-sub-bridge    
    config: /adapters/bridge-adapter.yaml 
...
```
The following adapter types (`adapters.type`) are supported by the launcher:

- dnp3-master (DNP3)
- dnp3-outstation (DNP3)
- modbus-master (MODBUS)
- modbus-outstation (MODBUS)
- pub-sub-bridge (bridging between pub/sub protocols such as NATS, MQTT, ZENOH, DDS*)
- oes-plug (the OES fictitious smart plug speaking UDP)
- ocpp-adapter (OCPP 1.6)*
- iccp-client (IEC60870-6)*
- iccp-server (IEC60870-6)*
- IEC61850-client (IEC61850)*
- IEC61850-server (IEC61850)*

(*) Required appropriate licensing

## Examples

To demonstrate, consider these two scenarios:

### Scenario 1

To be able to monitor the OES fictitious smart plug data, and turn it on/off using OpenFMB via NATS pub/sub protocol:
   - Note that the UDP OpenFMB Adapter doesn't support NATS.  We are utilizing the protocol-bridge functionality of the OpenFMB Adapter Framework extension

To run the adapters, do:

```bash
cd examples/scenario-1
docker-compose up
```

### Scenario 2

To be able to monitor the OES fictitious smart plug data and turn it on/off using DNP3 protocol
   - We are internally translating UDP datagram into DNP3
   - The OpenFMB adapter acts as a DNP3 outstation to serve data to a connected DNP3 master program
   - No NATS or any other pub/sub brokers required

To run the adapters, do:

```bash
cd examples/scenario-2
docker-compose up
```
