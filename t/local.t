#!perl -w
use Test;
BEGIN { plan tests => 1 }

use WWW::Yandex::TIC; 
my $ytic = new WWW::Yandex::TIC;
my $tic = $ytic->get('www.yandex.ru');
ok($tic);
exit;
__END__
