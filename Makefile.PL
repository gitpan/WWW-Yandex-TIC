use ExtUtils::MakeMaker;


WriteMakefile(
		NAME => "WWW::Yandex::TIC",
		VERSION_FROM => "lib/WWW/Yandex/TIC.pm",
		'dist' => { COMPRESS=>"gzip", SUFFIX=>"gz" },
		AUTHOR => 'Dmitry Bashlov <bashlov@cpan.org>',
		PREREQ_PM => {
			    'LWP::UserAgent' => 0,
			   }
		);
