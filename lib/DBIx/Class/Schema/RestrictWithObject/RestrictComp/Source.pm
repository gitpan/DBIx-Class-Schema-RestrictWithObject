package DBIx::Class::Schema::RestrictWithObject::RestrictComp::Source;

use strict;
use warnings;

=head1 DESCRIPTION

For general usage please see L<DBIx::Class::Schema::RestrictWithObject>, the information
provided here is not meant for general use and is subject to change. In the interest
of transparency the functionality presented is documented, but all methods should be
considered private and, as such, subject to incompatible changes and removal.

=head1 PRIVATE METHODS

=head2 resultset

Intercept call to C<resultset> and return restricted resultset

=cut

sub resultset {
  my $self = shift;
  my $rs = $self->next::method(@_);
  if (my $obj = $self->schema->restricting_object) {
    my $s = $self->source_name;
    $s =~ s/::/_/g;
    my $pre = $self->schema->restricted_prefix;
    my $meth = "restrict_${s}_resultset";

    #if a prefix was set, try that first
    if($pre){
      my $meth_pre = "restrict_${pre}_${s}_resultset";
      return $obj->$meth_pre($rs) if $obj->can($meth_pre);
    }
    $rs = $obj->$meth($rs) if $obj->can($meth);
  }
  return $rs;
}

1;

=head1 SEE ALSO

L<DBIx::Class::Schema::RestrictWithObject>,

=cut
