#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use File::Path qw(make_path);

# Directory for the best ligands
my $lig_dir = "best_ligands";  # Change this to your best ligand directory
chomp $lig_dir;

# Create a new directory for this run called 'best_five_results'
my $out_dir = "best_five_results";
make_path($out_dir) unless -d $out_dir;

# Open the directory for best ligands
opendir(my $dh, $lig_dir) or die "Cannot open directory '$lig_dir': $!\n";
my @ligands = grep { /\.pdbqt$/ && -f "$lig_dir/$_" } readdir($dh);
closedir($dh);

# Make sure there are exactly 5 ligands (optional sanity check)
if (@ligands != 5) {
    die "Error: Expected exactly 5 ligands in $lig_dir, found " . scalar(@ligands) . ".\n";
}

# Run Vina for each ligand
foreach my $ligand (@ligands) {
    my $ligand_path = "$lig_dir/$ligand";
    my ($name) = $ligand =~ /^(.+)\.pdbqt$/;

    my $output_pdbqt = "$out_dir/${name}_out.pdbqt";
    my $log_file     = "$out_dir/${name}_log.log";

    print "Processing ligand: $ligand\n";

    # Run AutoDock Vina with updated best_conf.txt
    system("vina --config best_conf.txt --ligand \"$ligand_path\" --out \"$output_pdbqt\" > \"$log_file\" 2>&1");
}
