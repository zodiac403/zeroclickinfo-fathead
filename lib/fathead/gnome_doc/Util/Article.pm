package Util::Article;

use Mojo::URL;
use Moo;

has [qw(title page)] => (
    is       => 'ro',
    required => 1,
);

has abstract => (
    is       => 'rwp',
    required => 1,
);

has [qw(aliases categories)] => (
    is      => 'ro',
    default => sub { [] },
);

has anchor => (
    is => 'ro',
);

has url => (
    is  => 'lazy',
    doc => 'full page URL including anchor',
);

sub _build_url {
    my ($self) = @_;
    '' . Mojo::URL->new($self->page->url)->fragment($self->anchor);
}

# Normalize the article for the DB - account for weird parser issues.
sub normalize {
    my ($self) = @_;
    my $abstract = $self->abstract;
    $abstract =~ s/\n/ /g;
    # Okay, the parser *really* hates links...
    my $dom = Mojo::DOM->new->parse($abstract);
    $dom->find('a')->map(tag => 'span');
    $abstract = $dom->to_string;
    $self->_set_abstract($abstract);
}

1;
