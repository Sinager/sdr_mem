#!/usr/bin/perl

 #
 # gqrx2sdr.pl
 # v 0.1 	28 Jul 2018 initial release
 #
 # converts a "bookmarks.csv" GQRX memory file into a "frequencies.xml" readble by SDR#
 # 
 # Copyright 2018 Stefano Sinagra IZ0MJE <sinager@tarapippo.net>
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


# hash to translate modes
my %mode = (
		"Narrow FM" => "NFM" ,
		"AM"  => "AM",
		"LSB" => "LSB",
		"USB" => "USB",
		"WFM (mono)" => "WFM",
		"WFM (stereo)" => "WFM",
		"WFM (oirt)" => "WFM",
		"CW-U" => "CW",
		"CW-L" => "CW" 
    );

# an array will contain all entries to form an XML block
my @entry;

# open output file
open(my $out, '>', 'frequencies.xml') or die "Output: $!\n";

# open input file
my $filename = 'bookmarks.csv';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

print $out '<?xml version="1.0"?>';
print $out "\n";
print $out '<ArrayOfMemoryEntry xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
print $out "\n";


while (my $row = <$fh>) {
  chomp $row;
  if (substr($row,0,12) =~ /\d{1,12}/ ) {
	  @entry = split(/; /,$row);
	  print $out "  <MemoryEntry>\n";
	  print $out "    <IsFavourite>false</IsFavourite>\n";
	  $entry[1] =~ s/  +//g;
	  print $out "    <Name>$entry[1]</Name>\n";
	  print $out "    <GroupName>$entry[4]</GroupName>\n";
	  $entry[0] = $entry[0] * 1;
	  print $out "    <Frequency>$entry[0]</Frequency>\n";
	  $entry[2] =~ s/  +//g;
      print $out "    <DetectorType>$mode{$entry[2]}</DetectorType>\n";
	  print $out "    <Shift>0</Shift>\n";
	  $entry[3] = $entry[3] * 1;
      print $out "    <FilterBandwidth>$entry[3]</FilterBandwidth>\n";
      print $out "  </MemoryEntry>\n";
	  }
}

print $out "</ArrayOfMemoryEntry>\n";

close $fh;
close $out;

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
