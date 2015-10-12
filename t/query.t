use v5.14;
use Test::More;
use Test::Output;

sub wdq { system( $^X, './bin/wdq', '-n', @_ ) }

my $sparql = <<SPARQL;
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
SELECT * WHERE {
\t?c <http://www.wikidata.org/prop/direct/P361> <http://www.wikidata.org/entity/Q544> .
}
SPARQL

# FIXME: use namespace prefixes in expanded SPARQL query
foreach my $query (
    '?c wdt:P361 wd:Q544',
    '{ ?c wdt:P361 wd:Q544 }',
    'SELECT * WHERE { ?c wdt:P361 wd:Q544 }', $sparql
  )
{
    stdout_is { wdq -q => $query } $sparql, substr $query, 0, 20;
}

stdout_is { wdq( -q => '?a ?b ?c', '--limit' => 1 ) }
"SELECT * WHERE {\n\t?a ?b ?c .\n}\nLIMIT 1\n", '--limit';

stdout_is { wdq( -q => 'SELECT * WHERE { ?a ?b ?c } LIMIT 2', '--limit' => 3 ) }
"SELECT * WHERE {\n\t?a ?b ?c .\n}\nLIMIT 3\n", '--limit (override)';

stdout_is { wdq( '-53q' => '?a ?b ?c', '--limit' => 6 ) }
"SELECT * WHERE {\n\t?a ?b ?c .\n}\nLIMIT 3\n", 'limit -3';

done_testing;