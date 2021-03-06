#!perl
#
# This file is part of POE::Component::Client::MPD.
# Copyright (c) 2007-2008 Jerome Quelin, all rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
#

use strict;
use warnings;

use Test::More;

my $nbtests = 32;
my @tests   = (
    # [ 'event', [ $arg1, $arg2, ... ], $sleep, \&check_results ]

    # all_items
    [ 'coll.all_items',              [], 0, \&check_all_items1        ],
    [ 'coll.all_items',        ['dir1'], 0, \&check_all_items2        ],

    # all_items_simple
    [ 'coll.all_items_simple',       [], 0, \&check_all_items_simple1 ],
    [ 'coll.all_items_simple', ['dir1'], 0, \&check_all_items_simple2 ],

    # items_in_dir
    [ 'coll.items_in_dir',           [], 0, \&check_items_in_dir1     ],
    [ 'coll.items_in_dir',     ['dir1'], 0, \&check_items_in_dir2     ],
);


# are we able to test module?
eval 'use POE::Component::Client::MPD::Test nbtests=>$nbtests, tests=>\@tests';
diag($@), plan skip_all => $@ if $@ =~ s/\n+BEGIN failed--compilation aborted.*//s;
exit;

#--

sub check_success {
    my ($msg) = @_;
    is($msg->status, 1, "command '" . $msg->request . "' returned an ok status");
}

sub check_all_items1 {
    my ($msg, $items) = @_;
    check_success($msg);
    is(scalar @$items, 6, 'all_items() return all 6 items');
    isa_ok($_, 'Audio::MPD::Common::Item', 'all_items() return') for @$items;
}

sub check_all_items2 {
    my ($msg, $items) = @_;
    check_success($msg);
    is(scalar @$items, 3, 'all_items() can be restricted to a subdir');
    is($items->[0]->directory, 'dir1', 'all_items() return a subdir first');
    is($items->[1]->artist, 'dir1-artist', 'all_items() can be restricted to a subdir');
}

sub check_all_items_simple1 {
    my ($msg, $items) = @_;
    check_success($msg);
    is(scalar @$items, 6, 'all_items_simple() return all 6 items');
    isa_ok($_, 'Audio::MPD::Common::Item', 'all_items_simple() return') for @$items;
}

sub check_all_items_simple2 {
    my ($msg, $items) = @_;
    check_success($msg);
    is(scalar @$items, 3, 'all_items_simple() can be restricted to a subdir');
    is($items->[0]->directory, 'dir1', 'all_items_simple() return a subdir first');
    is($items->[1]->artist, undef, 'all_items_simple() does not return full tags');
}

sub check_items_in_dir1 {
    my ($msg, $items) = @_;
    check_success($msg);
    is(scalar @$items, 4, 'items_in_dir() defaults to root' );
    isa_ok($_, 'Audio::MPD::Common::Item', 'items_in_dir() return') for @$items;
}

sub check_items_in_dir2 {
    my ($msg, $items) = @_;
    check_success($msg);
    is(scalar @$items, 2, 'items_in_dir() can take a param');
}
