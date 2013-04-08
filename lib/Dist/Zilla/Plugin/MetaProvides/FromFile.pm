use strict;
use warnings;

package Dist::Zilla::Plugin::MetaProvides::FromFile;
BEGIN {
  $Dist::Zilla::Plugin::MetaProvides::FromFile::AUTHORITY = 'cpan:KENTNL';
}
{
  $Dist::Zilla::Plugin::MetaProvides::FromFile::VERSION = '1.11060211';
}

# ABSTRACT: In the event nothing else works, pull in hand-crafted metadata from a specified file.
#
# $Id:$
use Moose;
use Moose::Autobox;
use Carp                ();
use Class::Load         ();
use Config::INI::Reader ();
use Dist::Zilla::MetaProvides::ProvideRecord;


use namespace::autoclean;
with 'Dist::Zilla::Role::MetaProvider::Provider';


has file => ( isa => 'Str', is => 'ro', required => 1, );


has reader_name => ( isa => 'ClassName', is => 'ro', default => 'Config::INI::Reader', );


has _reader => ( isa => 'Object', is => 'ro', lazy_build => 1, );


sub provides {
  my $self      = shift;
  my $conf      = $self->_reader->read_file( $self->file );
  my $to_record = sub {
    Dist::Zilla::MetaProvides::ProvideRecord->new(
      module  => $_,
      file    => $conf->{$_}->{file},
      version => $conf->{$_}->{version},
      parent  => $self,
    );
  };
  return $conf->keys->map($to_record)->flatten;
}


sub _build__reader {
  my ($self) = shift;
  Class::Load::load_class($self->reader_name);
  return $self->reader_name->new();
}


__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__

=pod

=head1 NAME

Dist::Zilla::Plugin::MetaProvides::FromFile - In the event nothing else works, pull in hand-crafted metadata from a specified file.

=head1 VERSION

version 1.11060211

=head1 SYNOPSIS

For a general overview of the C<MetaProvides> family, see L<< Dist::Zilla::Plugin::B<MetaProvides>|Dist::Zilla::Plugin::MetaProvides >>

This module is tailored to the situation where probing various files for C<provides> data is not possible, and you just want to declare some in an external file.

    [MetaProvides::FromFile]
    inherit_version = 0         ; optional, default = 1
    inherit_missing = 0         ; optional, default = 1
    file = some_file.ini        ; required
    reader_name = Config::INI::Reader ; optional, default = Config::INI::Reader
    meta_no_index               ; optional, useless

And in C<some_file.ini>

    [Foo::Package]
    file    = some/module/path
    version = 0.1

=head1 OPTION SUMMARY

=head2 inherit_version

Shared Logic with all MetaProvides Plugins. See L<Dist::Zilla::Plugin::MetaProvides/inherit_version>

=head2 inherit_missing

Shared Logic with all MetaProvides Plugins. See L<Dist::Zilla::Plugin::MetaProvides/inherit_missing>

=head2 meta_no_index

Shared Logic with all MetaProvides Plugins. See L<Dist::Zilla::Plugin::MetaProvides/meta_no_index>

However, given you're hard-coding the 'provides' map in the source file, and given that parameter
is intended to exclude I<discovered> modules from being indexed, it seems like the smart option would
be to simply delete the unwanted entries from the source file.

=head2 file

Mandatory path to a file within your distribution, relative to the distribution root, to extract C<provides> data from.

=head2 reader_name

A class that can be used to read the named file. Defaults to Config::INI::Reader.

It can be substituted by any class name that matches the following criteria

=over 4

=item * Can be instantiated via C<new>

    my $instance = $reader_name->new();

=item * has a C<read_file> method on the instance

    my $result = $instance->read_file( ... )

=item * C<read_file> can take the parameter C<file>

    my $result = $instance->read_file( file => 'path/to/file' )

=item * C<read_file> returns a hashref matching the following structure

    { 'Package::Name' => {
        file = 'path/to/file',
        version => '0.1',
    } }

=back

=head1 ROLES

=head2 L<Dist::Zilla::Role::MetaProvider::Provider>

=head1 PLUGIN FIELDS

=head2 file

=head3 type: required, ro, Str

=head2 reader_name

=head3 type: ClassName, ro.

=head3 default: Config::INI::Reader

=head1 PRIVATE PLUGIN FIELDS

=head2 _reader

=head3 type: Object, ro, built from L</reader_name>

=head1 ROLE SATISFYING METHODS

=head2 provides

A conformant function to the L<Dist::Zila::Role::MetaProvider::Provider> Role.

=head3 signature: $plugin->provides()

=head3 returns: Array of L<Dist::Zilla::MetaProvides::ProvideRecord>

=head1 BUILDER METHODS

=head2 _build__reader

=head1 SEE ALSO

=over 4

=item * L<Dist::Zilla::Plugin::MetaProvides>

=back

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
