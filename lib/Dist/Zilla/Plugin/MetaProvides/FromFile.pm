use strict;
use warnings;

package Dist::Zilla::Plugin::MetaProvides::FromFile;

# ABSTRACT: In the event nothing else works, pull in hand-crafted metadata from a specified file.
#
# $Id:$
use Moose;
use Moose::Autobox;
use Carp                ();
use Config::INI::Reader ();
use Dist::Zilla::MetaProvides::ProvideRecord;

=head1 ROLES

=head2 L<Dist::Zilla::Role::MetaProvider::Provider>

=cut

use namespace::autoclean;
with 'Dist::Zilla::Role::MetaProvider::Provider';

=head1 PLUGIN FIELDS

=head2 file

=head3 type: required, ro, Str

=cut

has file => ( isa => 'Str', is => 'ro', required => 1, );

=head2 reader_name

=head3 type: ClassName, ro.

=head3 default: Config::INI::Reader

=cut

has reader_name => ( isa => 'ClassName', is => 'ro', default => 'Config::INI::Reader', );

=head1 PRIVATE PLUGIN FIELDS

=head2 _reader

=head3 type: Object, ro, built from L</reader_name>

=cut

has _reader => ( isa => 'Object', is => 'ro', lazy_build => 1, );

=head1 ROLE SATISFYING METHODS

=head2 provides

A conformant function to the L<Dist::Zila::Role::MetaProvider::Provider> Role.

=head3 signature: $plugin->provides()

=head3 returns: Array of L<Dist::Zilla::MetaProvides::ProvideRecord>

=cut

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

=head1 BUILDER METHODS

=head2 _build__reader

=cut

sub _build__reader {
  my ($self) = shift;
  eval "require " . $self->reader_name . "; 1;" or die;
  return $self->reader_name->new();
}

=head1 SEE ALSO

=over 4

=item * L<Dist::Zilla::Plugin::MetaProvides>

=back

=cut

__PACKAGE__->meta->make_immutable;
1;

