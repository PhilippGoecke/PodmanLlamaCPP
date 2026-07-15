podman build --no-cache --rm --file Containerfile --tag llamacpp:demo .
podman run --interactive --tty --publish 8080:8080 llamacpp:demo
