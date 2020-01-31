requires 'perl', '5.008001';

require 'Plack';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

