requires 'perl', '5.008001';
requires 'JSON::XS';
requires 'Cache::LRU';
requires 'Net::DNS::Lite';
requires 'Furl';
requires 'URI';
requires 'URI::QueryParam';
requires 'Web::Query';
requires 'Encode';
requires 'Carp';
requires 'Moo';
requires 'namespace::clean';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

