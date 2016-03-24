#!/usr/bin/env perl
# clementine

use warnings;
use strict;

my $artist = "N/A";
my $title = "N/A";
my $album = "N/A";
my $year = "N/A";
my $arturl = "";
my $genre = "N/A";
my $bitrate = "N/A";
my $samplerate = "N/A";
my $progress = "0";

my $pos = `qdbus org.mpris.MediaPlayer2.clementine /Player PositionGet`;
my $length = "0";

my @msg = `qdbus org.mpris.MediaPlayer2.clementine /Player GetMetadata 2>/dev/null`;

foreach (@msg) {
	$title = $1 if /^title: (.*)/;
	$album = $1 if /^album: (.*)/;
	$artist = $1 if /^artist: (.*)/;
	$year = $1 if /^year: (.*)/;
	$arturl = $1 if /arturl: (.*)/;
	$genre = $1 if /genre: (.*)/;
	$bitrate = $1 if /audio-bitrate: (.*)/;
	$samplerate = $1 if /audio-samplerate: (.*)/;
	$length = $1 if /^mtime: (\d+)/;
}

$progress = int(100 * $pos / $length) if ( $pos && $length );

use File::Basename;
my $arturls = basename($arturl);

print "\n\n\n\n\n\n\n\n";
print "\${image ";
print "/tmp/${arturls}";
print " -p 0,750 -s 200x200}";

print "\${color2}\${font Sans:size=7,weight:bold}\${alignc}'${title}'\n\n";
print "\${color3}\${font Sans:size=7,weight:bold}\${alignr}${artist}\n";
print "\${color3}\${font Sans:size=7,style:italic}\${alignr}${album} (${year})\n\n";
print "\${color3}\${execbar echo " . $progress . "}\n\n";
print "\${color3}\${font Sans:size=7,style:italic}\${alignr}${genre} (${bitrate} k) \n\n";
