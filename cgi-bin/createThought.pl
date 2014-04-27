#!/usr/bin/perl
require "/var/www/cgi-bin/loadProperties.pl";
use DBI;
use Time::HiRes;
use CGI;
my $cgi=CGI->new;
print $cgi->header(-type=>'text/plain');
my $num=$cgi->param('random');
my $msg=$cgi->param('thought');
unless ($msg) { unless ($num) { $num=1; } }

my $startTime=[Time::HiRes::gettimeofday()];
my $dbh = DBI->connect("DBI:mysql:database=$prop{db};host=$prop{dbhost}",
                         "$prop{dbuser}", "$prop{dbpassword}",
                         {'RaiseError' => 1});

my @words;
my $thoughts;
open (LIST, "/usr/share/dict/words") or die;
while (<LIST>) {
  chomp;
  push(@words, $_);
}
close LIST;
foreach $iter (1..$num) {
  my $thought='';
  foreach $z (1..(rand(20)+1)) {
	$thought.="$words[rand($#words)] ";
  }
  $dbh->do("INSERT INTO thoughts (thought) VALUES ('$thought')");
  $thoughts.="  $thought\n";
}
if ($msg) {
  $dbh->do("INSERT INTO thoughts (thought) VALUES ('$msg')");
  $thoughts.="$msg\n";
  $num++;
}
my $elapsed=Time::HiRes::tv_interval($startTime);
print "Elapsed: $elapsed\n";
print "Number: $num\n";
print "Thoughts: $thoughts\n";
