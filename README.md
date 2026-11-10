# dev-box

A blank Ubuntu 24.04 sandbox for AI agents and other tools. Nothing agent-specific is installed. It runs as the non-root user `dev` (uid 1000) with passwordless sudo, and it is separate from the Hermes container so the two don't share keys or config.

## Build

```bash
docker build -t dev-box .
```

## Run (persistent, idle)

```bash
docker run -d \
  --name dev-box \
  --restart unless-stopped \
  -v "$(pwd)/workspace:/workspace" \
  dev-box
```

`./workspace` on the host is mounted at `/workspace` in the container. Put anything you want to keep there.

## Use

```bash
docker exec -it dev-box bash          # interactive shell
docker exec dev-box python3 --version # one-off command
```

## Maintenance

```bash
docker logs -f dev-box
docker stop dev-box
docker start dev-box
docker rm -f dev-box                  # remove container; ./workspace is kept
```

## Options

- No ports are published by default. Add `-p HOST:CONTAINER` only when a tool needs to listen.
- Limit resources: `--memory 2g --cpus 2`.
- Tighten capabilities: `--cap-drop ALL` (some tools may need specific caps added back).
- Give a tool its own secrets with `--env-file` or `-e`. Don't mount the Hermes data directory here.
