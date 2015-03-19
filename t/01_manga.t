use strict;
use utf8;
use Encode;
use Test::More 0.98;
use WebService::MediaArtsDatabase;

my $media_arts = new WebService::MediaArtsDatabase;
#my $res = $media_arts->manga({keyword_title => 'ドラゴンボール'});
my $res = $media_arts->manga('ドラゴンボール');
is ref $res, 'ARRAY';
is ref $res->[0], 'HASH';
ok exists $res->[0]{title};
ok exists $res->[0]{author};
ok exists $res->[0]{tag};
ok exists $res->[0]{separate_volume};
ok exists $res->[0]{magazine};
ok exists $res->[0]{material};
ok exists $res->[0]{original_picture};
ok exists $res->[0]{etc};
is $res->[0]{title}, encode('utf8','ドラゴンボール');


done_testing;

