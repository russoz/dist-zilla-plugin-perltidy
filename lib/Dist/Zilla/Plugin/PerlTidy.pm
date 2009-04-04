package Dist::Zilla::Plugin::PerlTidy;

# ABSTRACT: PerlTidy in Dist::Zilla

use Moose;
with 'Dist::Zilla::Role::FileMunger';

has '_perltidyrc';

sub munge_file {
  my ($self, $file) = @_;

  return $self->munge_perl($file) if $file->name    =~ /\.(?:pm|pl|t)$/i;
  return $self->munge_perl($file) if $file->content =~ /^#!perl(?:$|\s)/;
  return;
}

sub munge_perl {
  my ($self, $file) = @_;

  my $content = $file->content;

    my $_perltidyrc = ( $self->_perltidyrc and exists $self->_perltidyrc ) ?
        $self->_perltidyrc : undef;

  my $tided;
  require Perl::Tidy;
  Perl::Tidy::perltidy(
        source      => \$content,
        destination => \$tided,
        perltidyrc  => $_perltidyrc,
    );

  $file->content($tided);
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;


1;
__END__

=pod

=head1 DESCRIPTION

L<Perl::Tidy>

=cut
