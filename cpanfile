requires 'perl', '5.008001';

requires 'Plack';

requires 'Plack::App::Proxy';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

