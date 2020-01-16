package Plack::Middleware::App::P5SimpleHttpServer::Index;

use strict;
use warnings;

use File::Spec;

use parent qw(Plack::Middleware);

use Plack::Util::Accessor qw(root index encoding content_type);
use Plack::App::File;



sub call {
    if (ref($_[0]->index) eq 'ARRAY' && @{$_[0]->index}) {
        my $self = shift;
        my $env  = shift;

        my $dir = File::Spec->catdir($self->root, $env->{PATH_INFO});
        if (-d $dir) {

            for (@{$self->index}) {
                my $path = File::Spec->catfile($dir, $_);
                if (-f $path) {
                    $self->{file} ||= Plack::App::File->new({ root => $self->root || '.', encoding => $self->encoding, content_type => $self->content_type });
                    local $env->{PATH_INFO} = File::Spec->catfile($env->{PATH_INFO}, $_);
                    return $self->{file}->call($env);
                }
            }
        }

        return $self->app->($env);
    }

    return $_[0]->app->($_[1]);
}



1;