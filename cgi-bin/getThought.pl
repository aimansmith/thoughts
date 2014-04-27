#!/usr/bin/perl
print "Content-type: text/plain\n\n";
use DBI;
use CGI;
use Time::HiRes;
my $startTime=[Time::HiRes::gettimeofday()];

print $cgi->header(-type=>'text/plain');
my $thoughtNum=$cgi->param('thoughtNumber');

unless ($thoughtNum=~/^\d+$/) { 
  if ($thoughtNum=~/^rand/) { $thoughtNum="random"; }
  else { print "Invalid or missing thought number\n"; exit; }
}

my $dbh = DBI->connect("DBI:mysql:database=$prop{db};host=$prop{dbhost}",
                         "$prop{dbuser}", "$prop{dbpassword}",
                         {'RaiseError' => 1});
# Get a random number - make this a sub in next release
if ($thoughtNum eq "random") {
  my $max;
  my $getMax = $dbh->prepare("SELECT MAX(id) FROM thoughts");
  $getMax->execute();
  while (my @row = $getMax->fetchrow_array()) {
    $max=$row[0];
  }
  $getMax->finish();
  my $thoughtNum=int(rand($max-1));
  $thoughtNum++;
}
my $thought;
my $getThought = $dbh->prepare("SELECT thought FROM thoughts WHERE id=$thoughtNum");
$getThought->execute();
while (my @row = $getThought->fetchrow_array()) {
    $thought=$row[0];
}
$getThought->finish();

my $elapsed=Time::HiRes::tv_interval($startTime);
print "Elapsed: $elapsed\n";
print "Number: $thoughtNum\n";
print "Thought: $thought\n";
