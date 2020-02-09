package Plack::Middleware::App::P5SimpleHttpServer::Proxy;

use strict;
use warnings;

use File::Spec;

use parent qw(Plack::Middleware);

use Plack::Util::Accessor qw(root remote encoding content_type);

use Plack::App::Proxy;
use Data::Dumper;


sub call {
    if (ref($_[0]->remote) eq '' && defined($_[0]->remote)) {
        my $self = shift;
        my $env  = shift;

        unless (-e $env->{PATH_INFO}) {
            unless (defined($self->{proxy})) {
                $self->{proxy} = Plack::App::Proxy->new(remote => $self->remote);
                # if can
                $self->{proxy}->prepare_app();
            }

            return $self->{proxy}->call($env);
        }

        return $self->app->($env);
    }

    return $_[0]->app->($_[1]);
}



1;