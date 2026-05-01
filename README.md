# nix-packages

Nix packages for [vmvarela](https://github.com/vmvarela) tools.

## Usage

### With flakes

```bash
# Run directly
nix run github:vmvarela/nix-packages#sql-pipe

# Install to profile
nix profile install github:vmvarela/nix-packages#sql-pipe

# In your flake.nix
inputs.vmvarela-nix-packages.url = "github:vmvarela/nix-packages";
```

### Without flakes

```bash
nix-env -if https://github.com/vmvarela/nix-packages/archive/main.tar.gz
```

## Packages

| Package | Description |
|---------|-------------|
| [sql-pipe](https://github.com/vmvarela/sql-pipe) | Read CSV from stdin, query with SQL, write CSV to stdout |
