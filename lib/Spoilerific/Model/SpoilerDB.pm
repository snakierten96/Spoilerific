package Spoilerific::Model::SpoilerDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Spoilerific::Schema',

    connect_info => {
        dsn => 'dbi:mysql:spoilerific',
        user => 'root',
        password => '',
    }
);

=head1 NAME

Spoilerific::Model::SpoilerDB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Spoilerific>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Spoilerific::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.6

=head1 AUTHOR

Jason McIntosh

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
