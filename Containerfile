# Build-Stage
FROM debian:trixie-slim AS build

RUN apt update && apt install -y --no-install-recommends build-essential cmake git libcurl4-openssl-dev ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN git clone --depth 1 https://github.com/ggml-org/llama.cpp.git

WORKDIR /opt/llama.cpp

RUN cmake -B build -DCMAKE_BUILD_TYPE=Release -DLLAMA_CURL=ON \
  && cmake --build build --config Release -j$(nproc)

# Runtime-Stage
FROM debian:trixie-slim

RUN apt update && apt install -y --no-install-recommends libcurl4 libgomp1 ca-certificates wget \
  && rm -rf /var/lib/apt/lists/*

# Beispielmodell herunterladen
RUN mkdir -p /models && \
  wget -O /models/model.gguf https://huggingface.co/GnLOLot/MiniCPM5-1B-Claude-Opus-Fable5-V2-Thinking-GGUF/resolve/main/MiniCPM5-1B-Claude-Opus-Fable5-V2-Thinking-Q8_0.gguf?download=true

COPY --from=build /opt/llama.cpp/build/bin/llama-server /usr/local/bin/
COPY --from=build /opt/llama.cpp/build/bin/llama-cli /usr/local/bin/
COPY --from=build /opt/llama.cpp/build/bin/*.so* /usr/local/lib/

ENV LD_LIBRARY_PATH=/usr/local/lib

# Modelle hier ablegen (z.B. per Volume mounten: -v ./models:/models)
VOLUME /models
WORKDIR /models

EXPOSE 8080

# Standard: Server starten; Modellpfad beim Start angeben, z.B.:
# docker run -v ./models:/models -p 8080:8080 image -m /models/modell.gguf
ENTRYPOINT ["llama-server", "--host", "0.0.0.0", "--port", "8080"]
CMD ["-m", "/models/model.gguf"]
