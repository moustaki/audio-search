package TQApp::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

use Data::Dump qw( dump );

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config( namespace => '' );

=head1 NAME

TQApp::Controller::Root - Root Controller for TQApp

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( template => 'home.tt' );

    # Hello World
    #$c->response->body( $c->welcome_message );
}

=head2 default

Standard 404 error page

=cut

sub default : Path {
    my ( $self, $c ) = @_;
    $c->log->debug( dump $c->request );
    $c->stash( template => '404.tt' );
    $c->response->status(404);
}

sub api : Local {
    my ( $self, $c ) = @_;
}

sub signup : Local {
    my ( $self, $c ) = @_;
    if ( uc $c->req->method eq 'POST' ) {

        # internal proxy to api.
        # must bypass API authn check and mimic REST handling,
        # so we must manually do what dispatcher normally does.
        my $user_ctrl = $c->controller('V1::User');
        my $begin     = $user_ctrl->action_for('begin');
        $begin->execute( $user_ctrl, $c );
        $user_ctrl->zero_args_POST($c);
        my $end = $user_ctrl->action_for('end');
        $end->execute( $user_ctrl, $c );
    }
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') { }

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
