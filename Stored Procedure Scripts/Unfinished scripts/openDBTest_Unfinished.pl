#!/usr/bin/perl -w
use DBI;
use DBD::MySQL;

my $dbh = DBI->connect("dbi:ODBC:Driver={SQL Server};Server=localhost;UID=sa;PWD=ingeniux")
			or die "Can't connect to database: $DBI::errstr\n";
			
#$dbh->disconnect or warn "Disconnection error: $DBI::errstr\n";

$query = "SELECT pr.name FROM sys.procedures pr";
$query_handle = $dbh->prepare($query);
$query_handle->execute();

my $name;
$retVal = $query_handle->bind_columns(\$name);

while ($query_handle->fetch()) {
	print "$name \n";
}

exit;