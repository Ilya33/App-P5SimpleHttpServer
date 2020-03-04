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
        # TODO all locations in one named regexp?
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

    for my $p (@{$self->proxies}) {
        if ($env->{PATH_INFO} =~ $p->{_qr_location}) {
            if (1 == $p->{'try-files'} &&
                (-f File::Spec->catfile($self->root, $env->{PATH_INFO})))
            {
                next;
            }

            unless (defined($p->{_proxy})) {
                $p->{_proxy} = Plack::App::Proxy->new(remote => $p->{remote});
                $p->{_proxy}->prepare_app();
            }

            if (0 == $p->{_remote_has_uri}) {
                $env->{'plack.proxy.url'} = $p->{remote}.$env->{PATH_INFO};
            }
            else {
                $env->{'plack.proxy.url'} = $p->{remote}.substr($env->{PATH_INFO}, $p->{_location_len});
            }

            return $p->{_proxy}->call($env);
        }
    }

    return $self->app->($env);
}



1;