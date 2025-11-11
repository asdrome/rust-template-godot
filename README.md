# Rust Template for Godot

This is a template project for using Rust in Godot, created based on the official [Godot-Rust](https://godot-rust.github.io/book/intro/hello-world.html) guide. It serves as a starting point for developers who want to integrate Rust into their Godot projects for better performance and type safety.

## Features
- Template project to get started with Godot and Rust.
- Configured to work with Godot Engine and the [Godot Rust bindings](https://github.com/godot-rust/gdext).
- Provides a simple "Hello, World!" example to demonstrate how to integrate Rust code into Godot.
- Setup is based on the [Hello World](https://godot-rust.github.io/book/intro/hello-world.html) tutorial from the official Godot-Rust book.

## Version 1.1.0

Updated to the latest stable release of both Godot (4.5+) and Godot Rust (0.4+)

Breaking changes:
- The `rust` directory has been moved into the project, as the Godot project itself became the root of this repository.
- The `rust-template` dir dissapeared.
- The lib and the Rust crate have been renamed to `grust` to further reflect that are different setups.
  
> Current users should NOT update to reflect this change as you already have setup your work environment.

This decision was made to enable a plug-n-play version (after building) when downloading the template from the Godot Assets Store.

The minimum required version has been bumped to 4.5.
An experienced user will find easy to reverse this decision, if needed, and a newcomer will be meet with the latest stable release.

## Requirements
- **Godot Engine** version 4.5 or later.
- **Rust** installed. You can download it from the official website: https://www.rust-lang.org/
- **Cargo** – the Rust package manager, which is included when installing Rust.

## Installation

1. Clone this repository or download the ZIP.

2. Make sure you have Godot and Rust set up correctly.

3. Navigate to the `rust-template-godot` project folder and open the project with Godot.

4. Build the Rust code:
   - In the terminal, go to the project `grust` directory and run:
     ```
     cargo build
     ```

5. Run the project from Godot.

## Usage

Once everything is set up, you can start adding your own Rust code into the project. The template includes a simple example that prints "Hello, World!" to the Godot console, and adds a `Player` class based on Sprite2D. This can be extended to your game logic.

To modify the Rust code:
1. Open `src/lib.rs`.
2. Add your custom functionality or game logic written in Rust.
3. After making changes, rebuild your project using `cargo build` and test the integration in Godot.

### Reload

> This is only useful in Godot 4.2+ since it allows to import the changes without reloading the project. Since this template aims for 4.5+, this should not be a problem. Keep this in mind if you try a lesser version though.

## Project Structure

- `grust`: The Rust directory for writing code.
- `README.md`: This file.
- `LICENSE` The MIT license

## Troubleshooting

- If you encounter issues with Rust not building, ensure your environment is correctly configured by following the steps in the official [Godot-Rust Book](https://godot-rust.github.io/book/intro/hello-world.html).
- For specific issues with the Godot-Rust bindings, refer to the official [GitHub repository](https://github.com/godot-rust/gdext) or consult the community forums.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

The godot-rust Ferris icon was obtained from [their repository](https://github.com/godot-rust/assets) and its licence's details are explained [here](https://github.com/godot-rust/assets/blob/master/asset-licenses.md).

## Acknowledgments

- [Godot Engine](https://godotengine.org/)
- [Godot Rust](https://github.com/godot-rust/gdext) for their fantastic work on integrating Rust with Godot.
