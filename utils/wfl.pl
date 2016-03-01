if (!@ARGV[0]) { die ("Need a word to flip."); }
if (@ARGV[1] eq "-d") { $overlook = 1; }

@flipAry = split(/,/, lc(@ARGV[0]));

initWordCheck();
initDupeRead();

for $q (@flipAry)
{
readOneWord($q);
}

###########################################
#initWordCheck = mark all words so we can focus on the good stuff
sub initWordCheck
{

open(A, "c:/writing/dict/brit-1word.txt");

while ($a = <A>)
{
  chomp($a); $a = lc($a);
  $word{$a} = 1;
}

close(A);

}

###########################################
#initDupeRead = see what's already been done. Separate function or else it will be run several times.
sub initDupeRead
{
open(B, "c:/games/inform/compound.inform/source/flip.txt");
while ($b = <B>)
{
  $lineNum++;
  if (($b =~ /==/) && ($b !~ /=Found/)) { $b =~ s/^=*//g; chomp($b); $isDone{$b} = $lineNum; }
}

close(B);
}

###########################################
#readOneWord reads one word and possible flips
sub readOneWord
{

  $found = 0;
  $wordy = 0;

  if ((!$overlook) && ($isDone{$_[0]}))
 { print "$_[0] repeated, line $isDone{$_[0]} in flip.txt.\n"; return; }
 else
 { print "$_[0] not done yet.\n"; }
 $flip = $_[0];

open(B, ">>c:/games/inform/compound.inform/source/flip.txt");

print B "========$flip\n";

open(A, "c:/writing/dict/brit-1word.txt");

while ($a = <A>)
{
  chomp($a); $a = lc($a);
  if ($a =~ /^$flip/i)
  {
    $b = $a; $b =~ s/^($flip)(.*)/$2-$1/gi;
	$c = $a; $c =~ s/^$flip//gi;
	if ($b)
	{
    print B "$a to $b";
	if ($word{$c}) { print B " *** word"; $wordy++; }
	print B "\n";
    $found++;
	}
  }
  elsif ($a =~ /^$flip/i)
  {
    $b = $a; $b =~ s/(.*)($flip)$/$2-$1/g;
	$c = $a; $c =~ s/$flip$//g;
	if ($b)
	{
    print B "$a to $b";
	if ($word{$c}) { print " *** word"; $wordy++; }
	print B "\n";
    $found++;
	}
  }
}

close(A);
print B "====Found $found/$wordy for $flip\n";
print "====Found $found/$wordy for $flip\n";
close(B);
}