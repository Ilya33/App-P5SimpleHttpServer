# NAME

p5-simple-http-server - simple HTTP server for local testing

# INSTALL

    curl -L https://cpanmin.us | perl - --sudo https://github.com/Ilya33/App-P5SimpleHttpServer.git

or download binary file from https://github.com/Ilya33/App-P5SimpleHttpServer/releases

# SYNOPSIS

    p5-simple-http-server [OPTIONS] [DIRECTORY]

# DESCRIPTION

This is simple HTTP server for local testing. Do not use it in production.

# EXAMPLES

    # serve current directory on port 5000 and IP 0.0.0.0
    p5-simple-http-server
    
    # serve current directory on port 5678 and IP 0.0.0.0
    p5-simple-http-server -p=5678
    
    # serve current directory on port 5000 and IP 127.0.0.1
    p5-simple-http-server --host=127.0.0.1
    
    # serve /path/to/directory directory
    p5-simple-http-server /path/to/directory
    
    # serve current directory and "index.html" or "index.htm" be used as an index
    p5-simple-http-server --index="index.html index.htm"

If you want to serve Linux repository from iso just mount or unpack iso to
SOME\_DIRECTORY and run:

    p5-simple-http-server -p=5678 SOME_DIRECTORY

# BUGS

Please report any bugs through the web interface at
[https://github.com/Ilya33/App-P5SimpleHttpServer](https://github.com/Ilya33/App-P5SimpleHttpServer). Patches are always welcome.

# AUTHOR

Ilya Pavlov <ilux@cpan.org>

Contributors:

Fovik

# COPYRIGHT

Copyright 2019- Ilya Pavlov

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
