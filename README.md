# Lollipop

A simple, stylised 3D graphics engine for the visualisation of protein structures from the Protein Data Bank (pdb). Written from scratch in Lua and GLSL using the excellent LOVE2D framework.

Includes a cartoonish "spheres" representation by default, with depth based protein outlines, a full Phong shading model and real-time SSAO (as well as a heavily configurable config file)!

![A screenshot showing Lollipop in action](screenshot.png)

## Manual

### Dependencies

- [LOVE2D](https://www.love2d.org/)

The LOVE2D framework is required to run the raw source code. If a OS dependent executable is required, please contact me and I can package the source code to bundle LOVE2D, such that separate LOVE2D installation is not required. However,  if bundled it will be more difficult to change settings in the provided config file.

### Installation

The best way to download the software is by cloning this GitHub repository. On a linux system, using the terminal simply navigate to a convenient directory and clone the repo with a local git client:
```
cd ~/path/to/convenient/directory
git clone https://github.com/Sgt-Spaghetti/Lollipop
```
Now, if there are future updates that you wish to install, simply run
```
cd ~/path/to/this/program
git pull
```
and all changes from newer versions of this software will automatically be applied to your "installation".

### Running the software
If the installation was done as described above, and LOVE2D is installed on your machine, then:
- On a Linux system, using the terminal run love pointing to this software's directory:
```
love ~/path/to/the/folder/containing/this/README/file
```
- On windows or Mac, you can simply drag and drop the folder containing this README file onto the love.exe that was previously downloaded

Further instructions on running LOVE2D applications, such as running on android, can be found on the [LOVE wiki](https://www.love2d.org/wiki/Getting_Started).

### Configuration
This application comes with a config file, named config.lua. All the available config options are commented in the config file itself. The most important option is "input\_file", which points to the location of the PDB file to visualise. Change this to an absolute path to where the PDB file is stored.

The "colour\_series" option will determine the order that different protein chains are coloured. Every protein chain will coloured progressively working down the colour series in order of appearance in the PDB file. Colours will wrap around once the end of the series is reached. Colours are specified in RGBA with values ranging from 0 to 1. By convention, carbon atoms ("C") will be coloured lighter then other atoms ("X").

### Instructions

Keybindings:

- Rotation of molecules through the wasd/qe keys
- Translation of molecules with the ijkl/uo keys
