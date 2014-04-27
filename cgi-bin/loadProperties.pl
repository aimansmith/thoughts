#!/usr/bin/perl
my $propertiesFile="/opt/src/thoughts.properties";
our %prop;
open (PROPFILE, "$propertiesFile") or die "can't open props";
while (<PROPFILE>) { 
  chomp;
  if (/^(\w+)\s*=\s*(.*)$/) {
        $prop{$1}=$2;
  }
}
close PROPFILE;
