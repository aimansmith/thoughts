#!/usr/bin/perl
require "/var/www/cgi-bin/loadProperties.pl";
print "Content-type: text/plain\n\n";
use DBI;
use Time::HiRes;
my $startTime=[Time::HiRes::gettimeofday()];
my $dbh = DBI->connect("DBI:mysql:database=$prop{db};host=$prop{dbhost}",
                         "$prop{dbuser}", "$prop{dbpassword}",
                         {'RaiseError' => 1});
my $max;
my $getMax = $dbh->prepare("SELECT MAX(id) FROM thoughts");
  $getMax->execute();
  while (my @row = $getMax->fetchrow_array()) {
    $max=$row[0];
  }
  $getMax->finish();
my $rand=int(rand($max-1));
$rand++;
my $thought;
my $getThought = $dbh->prepare("SELECT thought FROM thoughts WHERE id=$rand");
  $getThought->execute();
  while (my @row = $getThought->fetchrow_array()) {
    $thought=$row[0];
  }
  $getThought->finish();

my $elapsed=Time::HiRes::tv_interval($startTime);
print "Elapsed: $elapsed\n";
print "Thought: $thought\n";
print "Number: $rand\n";
