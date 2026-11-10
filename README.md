# dev-box

A blank Ubuntu 24.04 sandbox. The container runs as the non-root user `dev` (uid 1000) with passwordless sudo. Tools attach to it with `docker exec`.

## Files

- `Dockerfile`: Ubuntu 24.04 base with common dev tools (git, curl, Python 3, Node.js, build-essential, jq, and others), plus the `dev` user. Idles with `sleep infinity`.
- `data/`: host folder mounted at `/data` in the container. Holds persistent work. Git-ignored.
- `.gitignore`: excludes `data/`.

## Build

```bash
docker build -t dev-box .
```

## Run (persistent, idle)

```bash
docker run -d \
  --name dev-box \
  --restart unless-stopped \
  -v "$(pwd)/data:/data" \
  dev-box
```

## Use

```bash
docker exec -it dev-box bash          # interactive shell
docker exec dev-box python3 --version # one-off command
docker exec dev-box whoami            # expect: dev
```

## Maintenance

```bash
docker logs -f dev-box
docker stop dev-box
docker start dev-box
docker rm -f dev-box                  # remove container; ./data is kept
```

## Options

- No ports are published by default. Add `-p HOST:CONTAINER` only when a tool needs to listen.
- Limit resources: `--memory 2g --cpus 2`.
- Tighten capabilities: `--cap-drop ALL` (some tools may need specific capabilities added back).
- Pass secrets per tool with `--env-file` or `-e`.
