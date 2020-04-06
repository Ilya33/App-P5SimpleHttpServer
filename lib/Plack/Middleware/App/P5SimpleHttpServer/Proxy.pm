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

        # TODO location~
        $p->{_remote_has_uri} = ($p->{remote} =~ m!^\w+://[^/]+/!) ?1 :0;
        $p->{_qr_location} = qr!^\Q$p->{location}\E!;
        $p->{_location_len} = length($p->{location});
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

    my $proxy = {_location_len => 0};

    for my $p (@{$self->proxies}) {
        if ($env->{PATH_INFO} =~ $p->{_qr_location}) {
            if ($p->{_location_len} > $proxy->{_location_len}) {
                $proxy = $p;
            }
        }
    }


    if (0 != $proxy->{_location_len} &&
        ( 0 == $proxy->{'try-files'} ||
        !(-f File::Spec->catfile($self->root, $env->{PATH_INFO})) )
    ) {
        unless (defined($proxy->{_proxy})) {
            $proxy->{_proxy} = Plack::App::Proxy->new(remote => $proxy->{remote});
            $proxy->{_proxy}->prepare_app();
        }

        if (0 == $proxy->{_remote_has_uri}) {
            $env->{'plack.proxy.url'} = $proxy->{remote}.$env->{PATH_INFO};
        }
        else {
            $env->{'plack.proxy.url'} = $proxy->{remote}.substr($env->{PATH_INFO}, $proxy->{_location_len});
        }

        return $proxy->{_proxy}->call($env);
    }

    return $self->app->($env);
}



1;