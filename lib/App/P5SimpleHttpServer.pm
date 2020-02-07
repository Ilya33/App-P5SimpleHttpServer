package App::P5SimpleHttpServer;

use strict;
use warnings;

use 5.008_005;

our $VERSION = '0.001';



sub get_repo_url {
    return 'https://github.com/Ilya33/App-P5SimpleHttpServer';
}



1;



__END__

=encoding utf-8

=head1 NAME

p5-simple-http-server - simple HTTP server for local testing

=head1 INSTALL

    curl -L https://cpanmin.us | perl - --sudo https://github.com/Ilya33/App-P5SimpleHttpServer.git

or download binary file from L<https://github.com/Ilya33/App-P5SimpleHttpServer/releases>

=head1 SYNOPSIS

    p5-simple-http-server [OPTIONS] [DIRECTORY]

=head1 DESCRIPTION

This is simple HTTP server for local testing. Do not use it in production.

=head1 EXAMPLES

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
SOME_DIRECTORY and run:

    p5-simple-http-server -p=5678 SOME_DIRECTORY

=head1 BUGS

Please report any bugs through the web interface at
L<https://github.com/Ilya33/App-P5SimpleHttpServer>. Patches are always welcome.

=head1 AUTHOR

Ilya Pavlov E<lt>ilux@cpan.orgE<gt>

Contributors:

Fovik

=head1 COPYRIGHT

Copyright 2019- Ilya Pavlov

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut