# Linux!

This command is used to run Cargo in the Linux terminal. By default, it initializes projects with cargo new and configures them with compression and optimized settings for the Release profile. The build command then compiles the program with these optimizations, saves the output in the release folder under a new name, and prints the file size.

Simple and practical.


# Install
    sudo bash install.sh

# Usage:
    cf --help
    cargof [TAB]

# Example:
    cf new --name exampl --bin

    cf new --name helloworld
    cd helloworld
    cf build
