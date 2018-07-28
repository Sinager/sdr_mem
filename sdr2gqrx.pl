#!/usr/bin/perl

 #
 # sdr2gqrx.pl
 # v 0.1 	28 Jul 2018 initial release
 #
 # converts a "frequencies.xml" SDR# memory file into a "bookmarks.csv" readble by GQRX
 # 
 # Copyright 2018 Stefano Sinagra <sinager@tarapippo.net>
 # 
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation; either version 2 of the License, or
 # (at your option) any later version.
 # 
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 # 
 # You should have received a copy of the GNU General Public License
 # along with this program; if not, write to the Free Software
 # Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 # MA 02110-1301, USA.

# a hash is created to store SDR# "Groups" that will be converted in GQRX "Tags"
# its keylist will be used to generate the taglist to be prepended to the GQRX memory file
my %tags;

# hash to translate modes
my %mode = (
		"NFM" => "Narrow FM",
		"AM"  => "AM",
		"LSB" => "LSB",
		"USB" => "USB",
		"WFM" => "WFM (mono)",
		"CW"  => "CW-U",
		"DSB" => "AM",
		"RAW" => "AM"
    );

# an array will contain all entries read from each XML block
my @entry;
$count = 0;

# open output file
open(my $out, '>', 'bookmarks.csv') or die "Output: $!\n";

# open input file
my $filename = 'frequencies.xml';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

while (my $row = <$fh>) {
  chomp $row;
  if ($row =~ /  <MemoryEntry>/ ) {$count = 1;}
  if ($row =~ /    <Name>/ ) { $entry[1] = substr($row,10,length($row)-18);} 
  if ($row =~ /    <GroupName>/ ) { 
	  $entry[4] = substr($row,15,length($row)-28);
	  $tags{$entry[4]} = 1;}
  if ($row =~ /    <Frequency>/ ) { $entry[0] = substr($row,15,length($row)-28);} 
  if ($row =~ /    <DetectorType>/ ) { $entry[2] = substr($row,18,length($row)-34);}
  if ($row =~ /    <FilterBandwidth>/ ) { $entry[3] = substr($row,21,length($row)-40);}
  if ($row =~ /  <\MemoryEntry>/ ) { 
		printf $out ("%*d", 12, $entry[0]);
		print $out "; ";
		printf $out ("%-*s", 25, substr($entry[1],0,25));
		print $out "; ";
		printf $out ("%-*s", 20, $mode{$entry[2]});
		print $out "; ";
		printf $out ("%*d", 10, $entry[3]);
		print $out "; ";
		print $out "$entry[4]\n";
		undef(@entry);
		$count = 0;
	}
}

close $fh;
close $out;

{
   local @ARGV = ("bookmarks.csv");
   local $^I = '.bac';
   while(<>){
      if ($. == 1) {
			print"# Tag name          ;  color\n";
			printf ("%*s", 30,"$_; #c0c0c0\n") for keys %tags;
			print "\n";      
			print "# Frequency ; Name                     ; Modulation          ;  Bandwidth; Tags\n";		
			}
      else {
         print;
      }
   }
}


# ==== sample of SDR# frequencies.xml entry ====
#  <MemoryEntry>
#    <IsFavourite>false</IsFavourite>
#    <Name>Soccorso Alpino</Name>
#    <GroupName>nazionale</GroupName>
#    <Frequency>68750000</Frequency>
#    <DetectorType>NFM</DetectorType>
#    <Shift>0</Shift>
#    <FilterBandwidth>20360</FilterBandwidth>
#  </MemoryEntry>
#
# List of modes: NFM AM LSB USB WFM DSB CW RAW
#
# ================================================================
#
# ==== sample of GQRX's bookmarks.csv file
# # Tag name          ;  color
# DMR                 ; #c0c0c0
# Prot Civ            ; #c0c0c0
#
# # Frequency ; Name                     ; Modulation          ;  Bandwidth; Tags
#    164150000; Prot Civ RM (DMR)        ; Narrow FM           ;      10000; Prot Civ,DMR
#
# List of modes and standard bandwidths 
# LSB 2700
# USB 2700
# AM  10000
# Narrow FM 10000
# WFM (mono)  160000
# CW-U 500
