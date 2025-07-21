#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use File::Path qw(make_path);
use POSIX qw(strftime);

print "Ligand directory:\t";
my $lig_dir = <STDIN>;
chomp $lig_dir;

# Output directory
my $out_dir = "vina_results";
make_path($out_dir) unless -d $out_dir;

# Open ligand directory
opendir(my $dh, $lig_dir) or die "Cannot open directory '$lig_dir': $!\n";
my @ligands = grep { /\.pdbqt$/ && -f "$lig_dir/$_" } readdir($dh);
closedir($dh);

# Run Vina for each ligand
foreach my $ligand (@ligands) {
    my $ligand_path = "$lig_dir/$ligand";
    my ($name) = $ligand =~ /^(.+)\.pdbqt$/;

    my $output_pdbqt = "$out_dir/${name}_out.pdbqt";
    my $log_file     = "$out_dir/${name}_log.log";

    print "Processing ligand: $ligand\n";

    # Run AutoDock Vina
    system("vina --config conf.txt --ligand \"$ligand_path\" --out \"$output_pdbqt\" > \"$log_file\" 2>&1");
}
