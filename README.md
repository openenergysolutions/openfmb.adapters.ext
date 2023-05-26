# OpenFMB Adapters Extensions

This repo consists of a Dockerfile that is used to build an "Extension" for OpenFMB Adapters.  

## Goals:

- To have a plug-in or extension that:
  - can be written in different programming languages
  - can internally speak common pub/sub (i.e. Zenoh bus)
  - can perform a specific functionality (for example: Speak custom UDP datagram, speak OCPP1.6, or store telemetry data in database, etc.)
  - can take advantages of the features currently implemented in the OpenFMB Adapters (MQTT, NATS, DNP3/MODBUS, etc)

## Zenoh Bus

[Zenoh](https://zenoh.io/) bus is used as an internal/inside-container communication channel between a plug-in/extension app and the [OpenFMB Adapter](https://openfmb.openenergysolutions.com/docs/adapter/) written by [OES](https://openenergysolutions.com/).

## Architecture

## How to Write a Plug-in for OpenFMB Adapter

Refer to this [repo](https://github.com/openenergysolutions/openfmb.adapters.udp.git) as the example of how to write a plug-in

## Build the Docker Image

Run the build script to build the Docker image:

```bash
./build.sh
```

## Launcher Configuration

Launcher is an app that acts as the entry point of the Docker image.

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
The following adapter types are supported by the launcher:

- dnp3-master
- dnp3-outstation
- modbus-master
- modbus-outstation
- pub-sub-bridge (bridging between pub/sub protocols such as NATS, MQTT, ZENOH, DDS)*
- oes-plug
- ocpp-adapter (OCPP 1.6)*
- iccp-client (IEC60870-6)*
- iccp-server (IEC60870-6)*
- IEC61850-client*
- IEC61850-server*

(*) Required appropriate licensing

## Examples

To demonstrate, consider these two scenarios:

### Scenario 1

To be able to access my OES plug data and turn it on/off using OpenFMB via NATS pub/sub protocol:
   - Note that the UDP plug-in doesn't support NATS.  We are taking advange of the protocol-bridge functionality of the OpenFMB Adapter
   - NATS server is required

To run the adapters, do:

```bash
cd examples/scenario-1
docker-compose up
```

### Scenario 2

To be able to access my OES plug data and turn it on/off using DNP3 protocol
   - We are internally translating UDP datagram into DNP3
   - The OpenFMB adapter acts as a DNP3 outstation to serve data to a connected DNP3 master program
   - No NATS or any other pub/sub brokers required

To run the adapters, do:

```bash
cd examples/scenario-2
docker-compose up
```
