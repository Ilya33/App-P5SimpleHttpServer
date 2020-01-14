package Plack::Middleware::App::P5SimpleHttpServer::Index;

use strict;
use warnings;

use File::Spec;

use parent qw(Plack::Middleware);

use Plack::Util::Accessor qw(root index encoding content_type);
use Plack::App::File;



sub call {
    my $self = shift;
    my $env  = shift;

    my $index = $self->index;
    if (ref($index) eq 'ARRAY' && @$index) {
        my $dir = File::Spec->catdir($self->root, $env->{PATH_INFO});
        if (-d $dir) {
            for (@$index) {
                my $path = File::Spec->catfile($dir, $_);
                if (-f $path) {
                    $self->{file} ||= Plack::App::File->new({ root => $self->root || '.', encoding => $self->encoding, content_type => $self->content_type });
                    local $env->{PATH_INFO} = File::Spec->catfile($env->{PATH_INFO}, $_);
                    return $self->{file}->call($env);
                }
            }
        }
    }

    return $self->app->($env);
}



1;