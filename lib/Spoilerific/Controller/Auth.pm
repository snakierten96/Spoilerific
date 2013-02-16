package Spoilerific::Controller::Auth;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Spoilerific::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub login : Local {
    my ($self, $c) = @_;

    if ( $c->req->parameters->{ intro_read } ) {
        $c->user_session->{ user_has_read_login_intro } = 1;
    }


    $c->user_session->{ original_request_path }
        = $c->req->parameters->{ original_request_path };

    unless ( $c->user_session->{ user_has_read_login_intro } ) {
        $c->res->redirect( $c->uri_for_action(
            '/auth/login_intro',
            { original_request_path => $c->user_session->{ original_request_path } }
        ) );
        return;
    }

    my $realm = $c->get_auth_realm('twitter');
    $c->res->redirect( $realm->credential->authenticate_twitter_url($c) );
}

sub login_intro : Local {
    my ( $self, $c ) = @_;

    if ( $c->req->parameters->{ original_request_path } ) {
        $c->user_session->{ original_request_path }
            = $c->req->parameters->{ original_request_path };
    }

    $c->stash->{ original_request_path } = $c->req->parameters->{ original_request_path };

    # If the user's already read the login spiel, move them along.
    if ( $c->user_session->{ user_has_read_login_intro } ) {
        $c->res->redirect( $c->uri_for_action(
            '/auth/login',
            { original_request_path => $c->user_session->{ original_request_path } },
        ) );
    }

}

sub logout : Local {
    my ( $self, $c ) = @_;

    my $redirect_path = $c->req->parameters->{ original_request_path };

    $c->logout;

    $c->res->redirect(
        $c->uri_for( $redirect_path || '/' )
    );
}

sub callback : Local {
    my ($self, $c) = @_;

    if (my $user = $c->authenticate(undef,'twitter')) {
        # Twitter login successful!
        $c->res->redirect(
            $c->uri_for( $c->user_session->{ original_request_path } || '/' )
        );
        delete $c->user_session->{ original_request_uri };
    }
    else {
        die "Eh?";
                # user doesn't have an account - either detect Twitter
                # credentials and create one, or return an error.
                #
                # Note that "request_token" and "request_token_secret"
                # are stored in $c->user_session as hashref variables under
                # the same names
    }
 }


# success: Placeholder just for login success
sub success : Local {
	my ($self, $c) = @_;

}

=head1 AUTHOR

Jason McIntosh

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
