#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#

package POE::Component::Client::MPD::Item::Song;

use strict;
use warnings;

use overload '""' => \&as_string;
use Readonly;

use base qw[ Class::Accessor::Fast POE::Component::Client::MPD::Item ];
__PACKAGE__->mk_accessors( qw[ album artist file id pos title track time ] );

#our ($VERSION) = '$Rev: 5645 $' =~ /(\d+)/;

Readonly my $SEP => ' = ';


#
# my $str = $song->as_string;
#
# Return a string representing $song. This string will be;
#  - either "album = track = artist = title"
#  - or     "artist = title"
#  - or     "title"
#  - or     "file"
# (in this order), depending on the existing tags of the song. The last
# possibility always exist of course, since it's a path.
#
sub as_string {
    my ($self) = @_;

    return $self->file unless defined $self->title;
    my $str = $self->title;
    return $str unless defined $self->artist;
    $str = $self->artist . $SEP . $str;
    return $str unless defined $self->album && defined $self->track;
    return join $SEP,
        $self->album,
        $self->track,
        $str;
}

1;

__END__

=head1 NAME

POE::Component::Client::MPD::Item::Song - a song object with some audio tags


=head1 DESCRIPTION

C<POE::Component::Client::MPD::Item::Song> is more a placeholder for a
hash ref with some pre-defined keys, namely some audio tags.


=head1 PUBLIC METHODS

=head2 Accessors

The following methods are the accessors to their respective named fields:
C<album()>, C<artist()>, C<file()>, C<id>, C<pos>, C<title()>, C<track()>,
C<time()>. You can call them either with no arg to get the value, or with
an arg to replace the current value.


=head2 Methods


=over 4

=item $song->as_string()

Return a string representing $song. This string will be:

=over 4

=item either "album = track = artist = title"

=item or "artist = title"

=item or "title"

=item or "file"

=back

(in this order), depending on the existing tags of the song. The last
possibility always exist of course, since it's a path.

=back


=head1 SEE ALSO

For all related information (bug reporting, mailing-list, pointers to
MPD and POE, etc.), refer to C<POE::Component::Client::MPD>'s pod,
section C<SEE ALSO>


=head1 AUTHOR

Jerome Quelin, C<< <jquelin at cpan.org> >>


=head1 COPYRIGHT & LICENSE

Copyright 2007 Jerome Quelin, all rights reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

=cut
