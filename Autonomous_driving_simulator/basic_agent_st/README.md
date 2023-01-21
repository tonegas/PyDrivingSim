# Project setup
1. Download or clone via git this repository;
2. Install one of the following IDE:
   1. Visual studio code (https://code.visualstudio.com/)
   2. CLion jetbrains (https://www.jetbrains.com/clion/)
3. Follow the guide for the Agent Setup;
4. Download or clone the simulation environment (https://github.com/tonegas/PyDrivingSim);
5. Follow the guide for the evirorment setup;

## Agent Setup
### Window
#### Setup using WSL:
1. Follow the guide to install awsl
   1. https://learn.microsoft.com/it-it/windows/wsl/install
2. Open a Linux shell and run:
   1. sudo apt-get update
   2. sudo apt-get install cmake
   3. sudo apt-get install clang
3. Open the folder project (in CLion: create Debug and Release profile);
4. Select the correct compiler WLS (https://www.jetbrains.com/help/clion/how-to-create-toolchain-in-clion.html)
5. Copy from the folder lib/win_WLS the communication library to the folder lib/
6. Compile the agent
7. Run the agent

#### Setup using visual studio:
1. Install visual studio professional (https://visualstudio.microsoft.com/it/vs/professional/)
2. Open the folder project (in CLion: create Debug and Release profile);
3. Select the correct compiler Visual Studio (https://www.jetbrains.com/help/clion/how-to-create-toolchain-in-clion.html)
4. Copy from the folder lib/win_visual_studio the communication library to the folder lib/
5. Compile the agent
6. Run the agent

#### Setup using MinGW
1. Install MSYS2 https://www.msys2.org/
2. Open the folder project (in CLion: create Debug and Release profile);
3. Select the correct compiler MinGW (https://www.jetbrains.com/help/clion/how-to-create-toolchain-in-clion.html)
4. Copy from the folder lib/win_mingw the communication library to the folder lib/
5. Compile the agent
6. Run the agent

### Linux
1. Open a Linux shell and run:
   1. sudo apt-get update
   2. sudo apt-get install cmake
   3. sudo apt-get install clang
2. Open the folder project (in CLion: create Debug and Release profile);
3. Copy from the folder lib/linux the communication library to the folder lib/
4. Compile the agent
5. Run the agent

### MacOs
1. Open a shell and run:
   1. brew update
   2. brew install cmake
   3. brew install clang
2. Open the folder project (in CLion: create Debug and Release profile);
3. Copy from the folder lib/macos or lib/macos_x86 the communication library to the folder lib/
4. Compile the agent
5. Run the agent