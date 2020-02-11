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
        croak("error");
    }

    # normalize pathes
}



sub call {
    my $self = shift;
    my $env  = shift;

    ## todo root in prepare_app?
    unless (-f File::Spec->catfile($self->root, $env->{PATH_INFO})) {
        for (@{$self->proxies}) {
            my $location = $_->{location};

            if ($env->{PATH_INFO} =~ m!^$location(?:/.*)?$!) { # TODO qr
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