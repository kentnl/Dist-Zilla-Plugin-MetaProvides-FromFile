use strict;
use warnings;
use Test::More;
use Test::DZil qw( simple_ini );
use Dist::Zilla::Util::Test::KENTNL 1.003001 qw( dztest );

my $test = dztest();
$test->add_file(
  'dist.ini',
  simple_ini(
    ['GatherDir'],
    [
      'MetaProvides::FromFile' => {
        file            => 'dist_meta_provides.ini',
        inherit_version => 0,
        inherit_missing => 1,
      }
    ]
  )
);
$test->add_file( 'dist_meta_provides.ini', <<'EOF');
[Imaginary::Package]
file = lib/Imaginary/Package.pm

[Imaginary::Package::With::Insane::Version]
file = lib/Imaginary/Package/Insane/Version.pm
version = 3.14159763
EOF
$test->add_file( 'lib/DZ2.pm', '' );

$test->build_ok;

$test->meta_path_deeply(
  '/provides/',
  [
    {
      'Imaginary::Package' => {
        'file'    => 'lib/Imaginary/Package.pm',
        'version' => '0.001'
      },
      'Imaginary::Package::With::Insane::Version' => {
        'file'    => 'lib/Imaginary/Package/Insane/Version.pm',
        'version' => '3.14159763'
      }
    },
  ],
  'Provides popuplation works'
);
note explain $test->builder->log_messages;

done_testing;
