use strict;
use warnings;

package Dist::Zilla::Plugin::MetaProvides::FromFile;
BEGIN {
  $Dist::Zilla::Plugin::MetaProvides::FromFile::AUTHORITY = 'cpan:KENTNL';
}
{
  $Dist::Zilla::Plugin::MetaProvides::FromFile::VERSION = '1.11060210';
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

version 1.11060210

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
