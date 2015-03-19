package WebService::MediaArtsDatabase;
use JSON::XS;
use Cache::LRU;
use Net::DNS::Lite;
use Furl;
use URI;
use URI::QueryParam;
use Web::Query;
use Encode;
use Carp;
use Moo;
use namespace::clean;
our $VERSION = "0.01";


$Net::DNS::Lite::CACHE = Cache::LRU->new( size => 5 );

has 'http' => (
    is => 'rw',
    required => 1,
    default  => sub {
        my $http = Furl::HTTP->new(
            inet_aton => \&Net::DNS::Lite::inet_aton,
            agent => 'WebService::MediaArtsDatabase/' . $VERSION,
            headers => [ 'Accept-Encoding' => 'gzip',],
        );
        return $http;
    },
);

my @keys = qw(
    title 
    author 
    tag 
    separate_volume 
    magazine 
    material 
    original_picture 
    etc
);

sub manga {
    my ( $self, $keyword, $query_param ) = @_;

    my $url = URI->new('http://mediaarts-db.jp/mg/results');
    $url->query_param('keyword_title', $keyword);
    map { $url->query_param( $_, $query_param->{$_} ) } keys %$query_param;
    my $wq = Web::Query->new_from_url($url);

    my @jsons;
    $wq->find('tbody')->each(sub {
        my(undef, $tbody) = @_;
        $tbody->find('tr')->each(sub {
            my @values;
            my $tr = $_[1];
            my $td = $tr->find('td');
            map { push @values, encode('utf-8', $td->get($_)->as_text) } (0..7);

            my %json;
            @json{@keys} = @values;
            push @jsons, \%json;
        });
    });

    return \@jsons; 

}


1;
__END__

=encoding utf-8

=head1 NAME

WebService::MediaArtsDatabase - 文化庁メディア芸術データベース( L<http://mediaarts-db.jp> ) 検索ラッパー

=head1 SYNOPSIS

    use WebService::MediaArtsDatabase;

    my $media_arts = new WebService::MediaArtsDatabase;
    my $res = $media_arts->manga('ドラゴンボール');

=head1 DESCRIPTION

WebService::MediaArtsDatabase is ...

=head1 LICENSE

Copyright (C) Hondallica.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Hondallica E<lt>hondallica@gmail.comE<gt>

=cut

