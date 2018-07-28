# sdr_mem
utilities to manipulate SDR frequency memory files

sdr2gqrx.pl   
Perl script to convert a SDR# "frequencies.xml" memory file into a "bookmarks.csv" usable by GQRX.
Output file shall be copied into your $HOME/.config/gqrx folder.

gqrx2sdr.pl   
Perl script to convert a "bookmarks.csv" GQRX memory file into a "frequencies.xml" usable by SDR#.
"bookmarks.csv" can be found in your $HOME/.config/gqrx folder.
Output file shall be copied into your SDR# directory.
