# NAME

p5-simple-http-server - simple HTTP server for local testing. Do not use it in
production.

# INSTALL

    curl -L https://cpanmin.us | perl - --sudo https://github.com/Ilya33/App-P5SimpleHttpServer.git

or download binary file from [https://github.com/Ilya33/App-P5SimpleHttpServer/releases](https://github.com/Ilya33/App-P5SimpleHttpServer/releases)

# SYNOPSIS

    p5-simple-http-server [OPTIONS] [DIRECTORY]

# OPTIONS

- **-h, --help**

    Shows this help

- **-v, --version**

    Shows p5-simple-http-server version

- **-o, --host**

    Binds to a TCP interface. Defaults to undef, which lets most server backends
    bind to the any (\*) interface. This option is only valid for servers which
    support TCP sockets.

- **-p, --port**

    Binds to a TCP port. Defaults to 5000. This option is only valid for servers
    which support TCP sockets.

- **-S, --socket**

    Listens on a UNIX domain socket path. Defaults to undef. This option is only
    valid for servers which support UNIX sockets.

- **-l, --listen**

    Listens on one or more addresses, whether "HOST:PORT", ":PORT", or "PATH"
    (without colons). You may use this option multiple times to listen on multiple
    addresses, but the server will decide whether it supports multiple interfaces.

- **--access-log**

    Specifies the pathname of a file where the access log should be written. By
    default, in the development environment access logs will go to STDERR.

- **--index**

    Like nginx's index directive

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
