# Zig Calc Project

Version: 0.2.0

## Overview
This project is developed using the Zig programming language and SDL2 library and it's my pet project to learn about Zig and SDL2. 

I am using [ikskuh's SDL.zig](https://github.com/ikskuh/SDL.zig) library.

Currently only tested on Windows 11 and Linux (with SDL2 installed).

![Preview](image.png)

## Features
- **VERY** basic calculator features
- Dark mode 😁
- I don't know, just test it

## Build Instructions
Make sure Zig (v0.14.0) is installed,
#### Windows
First download **Mingw** versions of both [SDL2](https://github.com/libsdl-org/SDL/releases/tag/release-2.32.8) and [SDL2_ttf](https://github.com/libsdl-org/SDL_ttf/releases/tag/release-2.24.0).

Copy /bin, /include and /lib folders inside <project_folder>/SDL2 folder.

#### Linux
Just install `SDL2` and `SDL2_ttf` using your package manager.

Run the following command to build and run the project:

`zig build run`

## Dependencies
- Zig (v0.14.0 or above)
- SDL2
- SDL2_ttf

## License
This project is licensed under the MIT License.

## Contributing
Feel free to fork, contribute, and improve the project!

