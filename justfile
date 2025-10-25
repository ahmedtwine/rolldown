set windows-shell := ["powershell"]
set shell := ["bash", "-cu"]

_default:
  @echo "Rolldown - Build & Run"
  @echo ""
  @echo "Usage: just dev"
  @echo ""
  @echo "See justfile.deprecated for all commands"

dev: _build
  @echo ""
  @echo "=========================================="
  @echo "Running: examples/basic-typescript"
  @echo "Source: examples/basic-typescript/index.ts"
  @echo "Output: examples/basic-typescript/dist/entry.js"
  @echo "=========================================="
  @echo ""
  @cd examples/basic-typescript && pnpm install --silent && pnpm run build && echo "" && echo "Output:" && node dist/entry.js
  @echo ""
  @echo "=========================================="
  @echo "Done! Check examples/basic-typescript/dist/ for bundled output"
  @echo "=========================================="

_build:
  @echo "Building rolldown..."
  @pnpm install --silent
  @echo "Step 1/3: Building Rust binding..."
  @cd packages/rolldown && pnpm run build-binding 2>&1 | grep -v "WARN" | grep -v "Unsupported engine" || true
  @echo "Step 2/3: Building JavaScript code..."
  @cd packages/rolldown && pnpm run build-node 2>&1 | grep -v "WARN" | grep -v "Unsupported engine" || true
  @echo "Step 3/3: Building plugin utilities..."
  @cd packages/pluginutils && pnpm run build 2>&1 | grep -v "WARN" | grep -v "Unsupported engine" || true
  @echo "Build complete!"
