my $to_read_first=1; 
my $prev;
while (<>)
{
	chomp;
	if (($prev ne $_) && !$to_read_first)
	{
		print $prev,"\n";
		$to_read_first=1;
	};
	$to_read_first=1-$to_read_first;
	$prev=$_;
}

