requires 'Mojo::Base';
requires 'Mojo::Collection';
requires 'Mojo::Exception';
requires 'Mojo::JSON::Pointer';
requires 'Mojo::Loader';
requires 'Mojo::Log';
requires 'Mojo::Template';
requires 'Mojo::UserAgent';
requires 'Safe::Isa';
requires 'Syntax::Keyword::Try';
requires 'Text::CSV';
requires 'perl', '5.028';
requires 'Future::AsyncAwait';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More', '0.98';
};


