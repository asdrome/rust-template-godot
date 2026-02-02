# Web Build Utilities & Architecture

This directory contains utility scripts and container definitions to streamline the WebAssembly (Wasm) export process for Godot using Rust.

## Architecture Decisions & Deviations from the Book

If you are coming from the official [Godot-Rust Book](https://godot-rust.github.io/book/), you might notice significant deviations in how we handle the Web export. This is intentional. Below is the reasoning behind these architectural choices.

### 1. Single-Threaded by Default
**Difference:** The official guide often leans towards threading support or leaves it as an option.
**Our Approach:** We prioritize **Single-Threaded** builds as the default.

**Why?**
As of Godot 4.3+, the web export landscape shifted. While multi-threading provides better performance, it requires specific HTTP headers (`COOP` and `COEP`) that many hosting providers (like itch.io or standard shared hosting) do not support easily or by default.
By default, this template produces a binary that "just works" on the web without complex server configuration, while still offering a multi-threaded option for advanced users.

### 2. The "Dual-Artifact" Strategy
We do, however, follow the guide recommendation of building both versions.
**Difference:** The guide provides a manual method to build both threaded and single-threaded artifacts.
**Our Approach:** The `web-build.sh` script compiles the crate **twice** during a release cycle.

1.  **Threaded Build:** Compiles with `--features wasm,threads`, outputting a binary that requires `SharedArrayBuffer`. The script renames this to `*.threads.wasm`.
2.  **Standard Build:** Compiles with `--features wasm-nothreads`, outputting a standard `*.wasm`.

This allows the `.gdextension` configuration file to map different binaries to different Godot Export Presets. You don't need to recompile Rust when switching between a "Web" and "Web Threads" export in the Godot Editor; both binaries are ready to go.

> This script works both locally or when using the container setup from the main [**README**](../../README.md). You **DON'T** need to use the container to benefit from the script.

### 3. Explicit Feature Flags
**Difference:** The guide suggests a threaded first approach.
**Our Approach:** We use a strict separation of features in `Cargo.toml`. We aim to follow the Godot's project [feature flags](https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html).

* `wasm`: The base wasm implementation of gdext is threaded, so in our script we included:
* `threads`: an empty (for now at least) feature to use as a marker. Following the Godot flags.
* `nothreads`: a marker to match single threaded builds.
* `wasm-nothreads`: This is a custom composite feature. It explicitly triggers `godot/experimental-wasm-nothreads`. This is crucial because `gdext` defaults to threaded Wasm. We must explicitly opt-out to ensure the generated Wasm doesn't crash on environments without thread support.

#### 3.1 Our reasoning

The guide assumes threading and allows to check for nothreading settings. We default to single thread but **don't** assume what you wan't to look for. Not even that either flags is inherently linked to targeting web.

You can either:

`#[cfg(feature = "nothreads")]` or `#[cfg(feature = "nothreads")]` and separately check if you are targeting wasm `#[cfg(feature = "wasm")]`.
Of course you may target a combination at the same time:

`#[cfg(all(target_family = "wasm", feature = "nothreads"))]`


### 4. Containerized Toolchain (Godot 4.5+ Alignment)
**Difference:** The book assumes a local setup of Emscripten (3.1.74 recommended) and LLVM.
**Our Approach:** We provide a `Containerfile` (Docker/Podman).

**Why?**
Godot 4.5+ is compiled against a modern version of Emscripten (4.0+). Using a system-installed Emscripten (often older, like 3.1.x) can lead to subtle runtime bugs or ABI mismatches.
The provided container ensures that:
1.  You are using the exact Nightly Rust toolchain required.
2.  You are using an Emscripten version compatible with the Godot 4.6 export templates.
3.  The build is reproducible across different developer machines (Windows/Linux/macOS).

> Note: You **DO NOT** need to use this container. It is provided as a reference implementation to guarantee a working build environment. We primarily develop using local toolchains, but since we cannot test every OS configuration, this container serves as a baseline.

Feel free to set up your environment locally; you can use the `Containerfile` as a checklist for missing dependencies.

## Usage

### Using the Containerfile

Check the **Usage** section of the main [README](../../README.md#using-the-containerized-env).

### Using the Build Script

The script automatically locates the project root, so you can run it from any directory.

From the project root:
```bash
./utils/web-build.sh [crate_name] [profile]
# Example: ./utils/web-build.sh grust release
```

For example, inside the utils folder:
```bash
./web-build.sh grust release
``` 