package Plack::Middleware::App::P5SimpleHttpServer::Proxy;

use strict;
use warnings;

use File::Spec;
use Carp qw(croak);

use parent qw(Plack::Middleware);

use Plack::App::Proxy;

use Plack::Util::Accessor qw(root proxies encoding content_type);



sub prepare_app {
    my $self = shift;

    if (ref($self->proxies) eq 'HASH') {
        $self->proxies([$self->proxies]);
    }
    elsif (ref($self->proxies) ne 'ARRAY') {
        croak('The "proxies" parameter MUST be ARRAY or HASH.');
    }

    for my $p (@{$self->proxies}) {
        for (qw(location remote try-files)) {
            if (!defined($p->{$_}) or ref($p->{$_}) ne '') {
                croak('The "proxies" parameter is invalid.');
            }
        }

        # TODO qr
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

    unless (-f File::Spec->catfile($self->root, $env->{PATH_INFO})) {
        for (@{$self->proxies}) {
            my $location = $_->{location};

            if ($env->{PATH_INFO} =~ m!^$location(?:/.*)?$!) {
                unless (defined($self->{proxy})) {
                    $self->{proxy} = Plack::App::Proxy->new(remote => $_->{remote});
                    $self->{proxy}->prepare_app();
                }

                $env->{'plack.proxy.url'} = $_->{remote}.
                    (substr($location, -1) ne '/' ?'/' :'').
                    (substr($env->{PATH_INFO}, 0, 1) eq '/' ?substr($env->{PATH_INFO}, 1) :$env->{PATH_INFO});

                return $self->{proxy}->call($env);
            }
        }
    }

    return $self->app->($env);
}



1;