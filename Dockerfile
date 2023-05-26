# SPDX-FileCopyrightText: 2022 Open Energy Solutions Inc
#
# SPDX-License-Identifier: Apache-2.0

FROM rust:1.69 as builder

ARG NUM_CORES=1

WORKDIR /home

RUN echo "num cores is: $NUM_CORES"

RUN apt-get update && apt-get install -y \ 
    build-essential \
    git \
    cmake \
    python3 \
    python3-pip \
    libssl-dev

# build and install nats.c
WORKDIR /home
RUN git clone --depth 1 --single-branch -b v2.6.0 https://github.com/nats-io/nats.c.git
WORKDIR /home/nats.c/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DNATS_BUILD_STREAMING=OFF ..
RUN cmake --build . --target install --parallel "$NUM_CORES"

# build and install zenoh-c
WORKDIR /home
RUN git clone --depth 1 --single-branch -b branch_0.5.0-beta.9-oes https://github.com/openenergysolutions/zenoh-c.git
WORKDIR /home/zenoh-c
RUN make
RUN make install

# install conan
RUN pip3 install conan==1.58.0
RUN conan profile new default --detect && conan profile update settings.compiler.libcxx=libstdc++11 default
RUN conan remote update conancenter https://center.conan.io false
RUN conan remote add bincrafters https://bincrafters.jfrog.io/artifactory/api/conan/public-conan false
RUN conan config set general.revisions_enabled=1

# build the application
COPY internal-openfmb.adapters /home/openfmb.adapters
WORKDIR /home/openfmb.adapters/build
RUN conan install --build missing ..
RUN cmake -DCMAKE_BUILD_TYPE=Release -DOPENFMB_LINK_STATIC=ON -DOPENFMB_USE_CONAN=ON -DMODBUS_VENDORED_DEPS=ON ..
RUN cmake --build . --parallel "$NUM_CORES"

# UDP plug-in
COPY openfmb.adapters.udp /home/openfmb.adapters.udp
WORKDIR /home/openfmb.adapters.udp
RUN rm -rf target
RUN cargo build --release

# supervisor
COPY openfmb.adapters.launcher /home/supervisor
WORKDIR /home/supervisor
RUN cargo build --release

# build running image
FROM debian:buster-slim

RUN apt-get update && apt-get install -y libpq5

# copy executables
COPY --from=builder /home/openfmb.adapters/build/application/openfmb-adapter /usr/bin/
COPY --from=builder /home/openfmb.adapters.udp/target/release/udp-adapter /usr/bin/udp-adapter
COPY --from=builder /home/supervisor/target/release/adapters-launcher /usr/bin/

EXPOSE 102

ENV RUST_LOG=info

ENTRYPOINT ["adapters-launcher"]
