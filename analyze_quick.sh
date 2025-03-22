#!/bin/bash

directory_name=6UMV

# Extract the directory name for naming files
 
# Run your gmx command here with the appropriate input and output files 

#Center ligand and/or protein molecules and fit the trajectory 	
echo 1 0 | gmx trjconv -f "$directory_name-sol6.trr" -n "$directory_name-sol.ndx" -s "$directory_name-sol2.tpr" -o "$directory_name-center.xtc" -center -pbc mol -ur compact 
echo 1 0 | gmx trjconv -f "$directory_name-center.xtc" -n "$directory_name-sol.ndx" -s "$directory_name-sol2.tpr" -o "$directory_name-fit.xtc" -fit rot+trans 

#Root mean square deviation analysis: least square distances gmx
echo 4 4 | gmx rms -f "$directory_name-center.xtc" -n "$directory_name-sol.ndx" -s "$directory_name-sol2.tpr" -o "$directory_name-rmsd1.xvg" -tu ns	
echo 4 4 | gmx rms -f "$directory_name-center.xtc" -n "$directory_name-sol.ndx" -s "$directory_name-sol5.tpr" -o "$directory_name-rmsd2.xvg" -tu ns

#Root mean square Fluctuation: C-alpha
echo 3 | gmx rmsf -f "$directory_name-center.xtc" -n "$directory_name-sol.ndx" -s "$directory_name-sol2.tpr" -o "$directory_name-rmsf.xvg" -res

#Make index file for my selection
echo -e "r 78-81 | r 84-85 | r 89-93 | r 95-97\nq" | gmx make_ndx -f "$directory_name-sol4.tpr" -o active_index.ndx

echo 4 18 | gmx rms -f "$directory_name-center.xtc" -n active_index.ndx -s "$directory_name-sol5.tpr" -o "$directory_name-rmsd_active.xvg" -tu ns

echo 2 | gmx gyrate -f "$directory_name-center.xtc" -n active_index.ndx -s "$directory_name-sol5.tpr" -o "$directory_name-gyrate.xvg" 
echo 19 | gmx gyrate -f "$directory_name-center.xtc" -n active_index.ndx -s "$directory_name-sol5.tpr" -o "$directory_name-gyrate-active.xvg" 

# Calculate the SASA for the defined index
gmx sasa -f "$directory_name-center.xtc" -s "$directory_name-sol4.tpr" -n active_index.ndx -o "$directory_name-sasa-time.xvg" -or "$directory_name-sasa-avg.xvg" -surface 1 -output 19

