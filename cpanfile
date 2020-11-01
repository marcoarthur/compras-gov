requires 'DDP';
requires 'Mojo::Base';
requires 'Mojo::Template';
requires 'Mojo::UserAgent';
requires 'perl', '5.028';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More', '0.98';
};


