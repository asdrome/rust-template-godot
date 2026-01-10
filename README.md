# Rust Template for Godot

This is a template project for using Rust in Godot, created based on the official [Godot-Rust](https://godot-rust.github.io/book/intro/hello-world.html) guide. It serves as a starting point for developers who want to integrate Rust into their Godot projects for better performance and type safety.

## Tutorial

I've made a basic video of the making of this template: [Tutorial](https://youtu.be/7T7HRiR1_94)
It doesn't go into deep detail since just follows the Godot Rust book but it may be of interest for someone.

## Features
- Template project to get started with Godot and Rust.
- Configured to work with Godot Engine and the [Godot Rust bindings](https://github.com/godot-rust/gdext).
- Provides a simple "Hello, World!" example to demonstrate how to integrate Rust code into Godot.
- Setup is based on the [Hello World](https://godot-rust.github.io/book/intro/hello-world.html) tutorial from the official Godot-Rust book.
- Dockerfile to setup a (experimental) web export enviroment. Bash script to simplify both threaded and non-threaded exports.

### Auto Reload

> This is only useful in Godot 4.2+ since it allows to import the changes without reloading the project. Since this template aims for 4.5+, this should not be a problem. Keep this in mind if you try a lesser version though.

## Changelog

### What's New in v1.2.0

Web (WebAssembly) Support: Ready-to-use configuration for web exports.

- Defaults to Single Thread to match Godot 4.3+ recommendations.
- Multithreading: Includes specific presets for both Single-threaded and Multi-threaded Web builds.
- Dockerized Build Environment: A dedicated Dockerfile to compile for Web without needing to install Emscripten/LLVM locally.
- A `web-build.sh` script to building both with and without multi-threading support. _Similar_ to the [docs](https://godot-rust.github.io/book/toolchain/export-web.html#building-both-with-and-without-multi-threading-support).

### Version 1.1.0

Updated to the latest stable release of both Godot (4.5+) and Godot Rust (0.4+)

Breaking changes:
- The `rust` directory has been moved into the project, as the Godot project itself became the root of this repository.
- The `rust-template` dir dissapeared.
- The lib and the Rust crate have been renamed to `grust` to further reflect that are different setups.
  
> Current users should NOT update to reflect this change as you already have setup your work environment.

This decision was made to enable a plug-n-play version (after building) when downloading the template from the Godot Assets Store.

The minimum required version has been bumped to 4.5.
An experienced user will find easy to reverse this decision, if needed, and a newcomer will be met with the latest stable release.

## Requirements
- **Godot Engine** version 4.5 or later.
- **Rust** installed. You can download it from the official website: https://www.rust-lang.org/
- **Cargo** – the Rust package manager, which is included when installing Rust.

### Web Export (Experimental Feature)

Additional requirements as described (briefly) in the [documentation](https://godot-rust.github.io/book/toolchain/export-web.html):
- **Cargo Nightly** toolchain. Requires the wasm32-unknown-target.
- **Emscripten**. I recommend using 4.0+ version (as opposed to the 3.1.74v from the guide) since main Godot is compiled against it. [See the docs](https://docs.godotengine.org/en/latest/engine_details/development/compiling/compiling_for_web.html#doc-compiling-for-web).
  > Emscripten itself has some dependencies, including Python.

- **LLVM**. Some additional libraries may be required for this. IDocumentation on this is sparse, but you can refer to the `./grust/utils/Dockerfile` to see what I'm using on top of a functional `cargo` setup in Debian.
  > Notably `clang` and `gcc-multilib` seem to be needed for cross-compiling with `emcc`.

- For the containerized env, either **[Podman](https://podman.io/)** or **Docker**.

## Installation

1. Either install from the **Godot Assets Store**, clone this repository or download the ZIP.

2. Make sure you have Godot and Rust set up correctly.

3. Navigate to the `rust-template-godot` project folder and open the project with your code editor.

4. Build the Rust code:
   - In the terminal, go to the project `grust` directory and run:
     ```
     cargo build
     ```

5. Open, and run the project from Godot.

## Usage

Once everything is set up, you can start adding your own Rust code into the project. The template includes a simple example that prints "Hello, World!" to the Godot console, and adds a `Player` class based on Sprite2D. This can be extended to your game logic.

To modify the Rust code:
1. Open `src/lib.rs`.
2. Add your custom functionality or game logic written in Rust.
3. After making changes, rebuild your project using `cargo build` and test the integration in Godot.

### Web Export (Experimental Feature)

There is a suggested enviroment Dockerfile, you may use it or read the file to see what could be missing in your dev enviroment.

#### Build Script

If you already have everything set up locally you can use (from the `grust` directory) the build script to generate both the single-threaded, and multithreaded targets:
```bash
./utils/web-build.sh [CRATE_NAME] [PROFILE]
```
> Defaults to `./utils/web-build.sh grust` (Omitting --profile in cargo defaults to `debug`)

After running the script, you are good to go. The `.gdextension` file points to this default generated libraries.

#### Using the containerized env

If you are having troubles to setup your local env, you may choose to use the provided Dockerfile to compile the web export.

This Dockerfile uses a `rust:slim` image, Debian based, to provide a functional setup with Emscripten, LLVM and the latest stable version of Godot (to generate the custom API).

I use `podman`, which is a drop-in replacement for `docker`. Change the command if needed.

#### Build the image
From the `grust` directory:
```bash
podman build -t godot-rust-dev -f utils/Dockerfile .
```
> Note the trailing `.`

#### Example of running
This is my personal way to run it, the use of this flags is beyond the scope of this guide. I can just tell you that this creates a one time container, that uses the current directory (`grust`) so the files are generated in it. Uses the global `.cargo` cache to store the packages between runs.

Running this, allows us to use the container in the current shell:
```bash
podman run --rm -it -v .:/workspace:Z -v ~/.cargo:/usr/local/cargo/registry:Z -w /workspace godot-rust-dev   
```

Or we can directly use the previous `web-build.sh` script to generate the default targets:
- Debug
```bash
podman run --rm -it -v .:/workspace:Z -v ~/.cargo:/usr/local/cargo/registry:Z -w /workspace godot-rust-dev ./utils/web-build.sh grust
```
- Release
```bash
podman run --rm -it -v .:/workspace:Z -v ~/.cargo:/usr/local/cargo/registry:Z -w /workspace godot-rust-dev ./utils/web-build.sh grust release
```

Running this **from the** `grust` directory, creates the files expected by Godot.

## Project Structure

- `grust`: The Rust directory for writing code.
- `README.md`: This file.
- `LICENSE` The MIT license

```
.
├── project.godot          # Godot project root
└── grust/                 # Rust project root
    ├── Cargo.toml
    └── utils/
        ├── Dockerfile
        └── web-build.sh
```

## Troubleshooting

- If you encounter issues with Rust not building, ensure your environment is correctly configured by following the steps in the official [Godot-Rust Book](https://godot-rust.github.io/book/intro/hello-world.html).
- For specific issues with the Godot-Rust bindings, refer to the official [GitHub repository](https://github.com/godot-rust/gdext) or consult the community forums.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

The godot-rust Ferris icon was obtained from [their repository](https://github.com/godot-rust/assets) and its licence's details are explained [here](https://github.com/godot-rust/assets/blob/master/asset-licenses.md).

## Acknowledgments

- [Godot Engine](https://godotengine.org/)
- [Godot Rust](https://github.com/godot-rust/gdext) for their fantastic work on integrating Rust with Godot.
