package TQApp::Model::Media;
use strict;
use base qw( TQApp::Base::Model::RDBO );
use MRO::Compat;
use mro 'c3';
use Data::Dump qw( dump );
use Carp;

__PACKAGE__->config(
    name      => 'TQ::Media',
    page_size => 50,
);

sub make_query {
    my $self = shift;
    my $q    = $self->next::method(@_);

    # apply authz
    my $c = $self->context;
    my $user = $c->stash->{user} or confess "User required";
    push @{ $q->{query} }, ( user_id => $user->id );

    # trim results if asked
    # cxc-minimal to avoid pulling transcript when not needed (list view)
    if ( $c->req->params->{'cxc-minimal'} ) {
        $q->{select} = [qw( uuid name updated_at status uri )];
    }

    return $q;
}

1;
