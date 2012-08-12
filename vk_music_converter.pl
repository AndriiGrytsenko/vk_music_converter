#!/usr/bin/perl

use IO::File; 
use Getopt::Std;
use MP3::Tag;
use File::Copy;

use strict;


sub PackAndSave { 
    # this function pack binary into file
    my ($fh, $hex) = @_;
    my $packed = pack( "H32", $hex);
    
    $fh->print ( $packed );
}

sub TryToGetTag {
    # this function try to fetch MP3 tags and if it does it renames output file to 'artist - title.mp3'
    my ($file,$out_dir) = @_;
    my $mp3 = MP3::Tag->new($file);
    my ($artist, $title ) = ($mp3->autoinfo())[2,0];
    if ( $artist ne '' and $title ne '' ){
	my $new_file = "$out_dir/$artist - $title.mp3";
	move($file, $new_file);
    }
    return 0;
}

sub GetOutputName {
    # this function get output file from original file
    my ($file,$out_dir) = @_;
    $file =~ /.*\/([^\/]*)$/;
    my $result = "$out_dir/$1";
    return $result;
}

sub ProcessFile {
    # this is the main function which is process original file and save it in binary format
    my ($file, $out_dir) = @_;
    my $out_file = GetOutputName($file, $out_dir);
    unlink($out_file);
    my $rd = IO::File->new ( "$file", '<' );
    my $fh = IO::File->new( "$out_file", '>>' );

    $fh->binmode;

    my $read_flag = 0;
    my $mp3_header = '00000000:  49  44  33';
    while(<$rd>){
        if ( $_ =~ /$mp3_header/ or $read_flag) {
    	    $read_flag = 1;
    	    my @hex_array = (split(/\s+/,$_))[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
	    my $hex = join('',@hex_array);
    	    PackAndSave($fh, $hex);
	}
    }
    $fh->close;
    $rd->close;
    TryToGetTag($out_file, $out_dir);
}


#
# The program body starts here
# 

my %opts;
getopt('fdo', \%opts);

if ( !defined($opts{'o'}) ) {
    print "Usage: vk_music_converter [-f filename| -d directory] -o output_directory\n";
    exit;
}

# create output directory if doesn't exist
mkdir $opts{'o'} if ( ! -d $opts{'o'} );


if ( defined($opts{'d'}) ) {
    my @files = glob("$opts{'d'}/*");
    foreach my $file ( @files ){
	
	ProcessFile($file, $opts{'o'});
    }
} elsif ( defined($opts{'f'} )) {
    ProcessFile($opts{'f'}, $opts{'o'});
}

