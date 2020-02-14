package Plack::Middleware::App::P5SimpleHttpServer::Index;

use strict;
use warnings;

use File::Spec;
use Carp qw(croak);

use parent qw(Plack::Middleware);

use Plack::App::File;
use Plack::Util::Accessor qw(root index encoding content_type);



sub prepare_app {
    my $self = shift;

    if (ref($self->index) eq '') {
        $self->index( defined($self->index) ?[$self->index] :[] );
    }
    elsif (ref($self->index) ne 'ARRAY') {
        croak('The "index" parameter MUST be ARRAY or string.');
    }

    if (ref($self->root) ne '') {
        croak('The "root" parameter MUST be string.');
    }
    unless (defined($self->root)) {
        $self->root('.');
    }
}



sub call {
    my $self = shift;
    my $env  = shift;

    my $dir = File::Spec->catdir($self->root, $env->{PATH_INFO});
    if (-d $dir) {
        for (@{$self->index}) {
            my $path = File::Spec->catfile($dir, $_);

            if (-f $path) {
                $self->{_file} ||= Plack::App::File->new({
                    root            => $self->root,
                    encoding        => $self->encoding,
                    content_type    => $self->content_type
                });

                local $env->{PATH_INFO} = File::Spec->catfile($env->{PATH_INFO}, $_);
                return $self->{_file}->call($env);
            }
        }
    }

    return $self->app->($env);
}



1;