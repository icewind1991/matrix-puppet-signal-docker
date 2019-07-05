# matrix-puppet-signal-docker

Docker image for matrix-puppet-signal

## Usage

- Download the [sample config](https://github.com/matrix-hacks/matrix-puppet-signal/blob/master/config.sample.json)
- Fill in the same config and rename to `config.json`
- Start signal link process `docker run -it --rm -v $(pwd)/config.json:/conf/config.json -v $(pwd)/data:/data icewind1991/matrix-puppet-signal link`
- Scan the QR code with signal on your phone to finish registration
- Generate `signal-registration.yaml` using `docker run -it --rm -v $(pwd)/config.json:/conf/config.json icewind1991/matrix-puppet-signal registration "http://signal-bridge.example.com"`
- Run bridge `docker run -it --rm -v $(pwd)/config.json:/conf/config.json -v $(pwd)/signal-registration.json:/conf/signal-registration.json -v $(pwd)/data:/data icewind1991/matrix-puppet-signal`

## Details

- Persitance data will be stored at `/data`
- Config will be loaded from `/conf/config.json` and `/conf/signal-registration.json`

