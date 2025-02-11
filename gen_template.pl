#!/bin/perl

use strict;
use warnings;

use Getopt::Long;
use Template;
use File::Basename;

# cmd filename [--nofile | --no-file | --nf | --x]

my $nofile = undef;

GetOptions("nofile|no-file|nf|x"=>\$nofile);

die "ERROR:\tMISSING ARGUMENT" if (scalar @ARGV) != 1;

sub get_proj_name {
	# TODO
}

sub get_template_dir {
	return dirname(__FILE__).'/t';
}

my $filename = shift @ARGV;
my $name = '';
my $ext = '';

my $template_file;

my $includes = get_template_dir;
my %ext_list = (
	c	=>	"tmpl_c.tt",
	h	=>	"tmpl_h.tt",
	cpp	=>	"tmpl_cpp.tt",
	C	=>	"tmpl_cpp.tt",
	pl	=>	"tmpl_perl.tt",
	perl	=>	"tmpl_perl.tt",
	pm	=>	"tmpl_pm.tt",
	java	=>	"tmpl_java.tt",
	xml	=>	"tmpl_xml.tt"
);

my %special_files = (
	'CMakeLists.txt'	=>	'tmpl_CMakeLists.tt',
	'Makefile'		=>	'tmpl_Makefile.tt',
);

if(grep /$filename/, keys %special_files)
{
	$template_file = $special_files{$filename};
	$name = get_proj_name;
}
else
{
	$filename =~ /\A(.*)\.(\w*)\Z/;
	$name = $1;
	$ext = $2;

	exit unless($ext and $ext_list{$ext});
	$template_file = $ext_list{$ext};
}

my $vars = {name => $name};

my $processed = "";
my $config = {
	INCLUDE_PATH	=>	$includes,
	OUTPUT		=>	\$processed,
};

my $template = Template->new($config);

$template->process($template_file,$vars) or die $template->error;

chomp $processed;

print $processed;

unless($nofile)
{
	open FILEOUT,'>',"$filename";
	print FILEOUT $processed;
	close FILEOUT;
}
