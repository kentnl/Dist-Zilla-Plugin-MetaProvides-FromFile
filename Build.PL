
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Dist::Zilla::App::Tester" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => "0.88"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "In the event nothing else works, pull in hand-crafted metadata from a specified file.",
  "dist_author" => [
    "Kent Fredric <kentnl\@cpan.org>"
  ],
  "dist_name" => "Dist-Zilla-Plugin-MetaProvides-FromFile",
  "dist_version" => "1.11060209",
  "license" => "perl",
  "module_name" => "Dist::Zilla::Plugin::MetaProvides::FromFile",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "Class::Load" => 0,
    "Config::INI::Reader" => 0,
    "Dist::Zilla::MetaProvides::ProvideRecord" => 0,
    "Dist::Zilla::Plugin::MetaProvides" => "1.11034201",
    "Dist::Zilla::Role::MetaProvider::Provider" => 0,
    "Moose" => 0,
    "Moose::Autobox" => 0,
    "namespace::autoclean" => 0,
    "perl" => "5.006",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
