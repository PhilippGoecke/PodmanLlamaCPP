podman build --no-cache --rm --file Containerfile --tag llamacpp:demo .
#podman run --interactive --tty --publish 8080:8080 llamacpp:demo
podman run --interactive --tty --publish 8080:8080 --device nvidia.com/gpu=all --security-opt=label=disable llamacpp:demo # NVIDIA
#podman run --interactive --tty --publish 8080:8080 --device /dev/kfd --device /dev/dri --group-add keep-groups --security-opt=label=disable llamacpp:demo # AMD
