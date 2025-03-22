#!/bin/bash

# Load the GROMACS environment (adjust this path according to your setup)


# Define variables
protein_file="6UMV"       # Protein structure file
#ligand_file="ligand.pdb"         # Ligand structure file
#forcefield="ffamber99sb-ildn"   # Force field name (choose the appropriate one)
water_model="spc216"             # Water model (choose the appropriate one)
GROMACS="gmx"


# Step 1: Generate Coordinate Files
echo 1 | $GROMACS pdb2gmx -f $protein_file.pdb  -o $protein_file.gro -p $protein_file.top -ignh -ter -ff amber14sb_OL15


# Step 2: Create simulation box
$GROMACS editconf -f $protein_file.gro -o $protein_file-box.gro -c -d 1.5 -bt cubic

# Step 3: Create Solvent Box
$GROMACS solvate -cp $protein_file-box.gro -cs $water_model.gro -o $protein_file-sol.gro -p $protein_file.top 

# Step4: Create an index file
echo q | $GROMACS make_ndx -f $protein_file-sol.gro -o index.ndx

#Step 5: Create a run file (.tpr file)
$GROMACS grompp -f mdp.mdp -c $protein_file-sol.gro -n index.ndx -p $protein_file.top -o $protein_file-sol.tpr

# Step 5: Neutralize the System (if necessary)
echo SOL | $GROMACS genion -s $protein_file-sol.tpr -o $protein_file-solnl.gro -p $protein_file.top -neutral

echo q | $GROMACS make_ndx -f $protein_file-solnl.gro -o index.ndx

#Step 6a: Create a run file (.tpr file) for ionic strength
$GROMACS grompp -f mdp.mdp -c $protein_file-solnl.gro -n index.ndx -p $protein_file.top -o $protein_file-solnl.tpr

# Step 6b: Ionize the System (if necessary)
echo SOL | $GROMACS genion -s $protein_file-solnl.tpr -o $protein_file-sol1.gro -p $protein_file.top -conc 0.15

cat $protein_file.top > $protein_file-sol.top

# Step 7: Index file
echo q | $GROMACS make_ndx -f $protein_file-sol1.gro -o $protein_file-sol.ndx

cat em.mdp > $protein_file-sol1.mdp

cat nvt.mdp > $protein_file-sol2.mdp

cat npt1.mdp > $protein_file-sol3.mdp

cat npt2.mdp > $protein_file-sol4.mdp

cat prod.mdp > $protein_file-sol5.mdp

#####  Energy minimization

#Create mdrun input file
gmx grompp -f $protein_file-sol1.mdp -c $protein_file-sol1.gro -n $protein_file-sol.ndx -p $protein_file-sol.top -o $protein_file-sol1.tpr -maxwarn 2

#Energy minimize the system.
gmx mdrun -s $protein_file-sol1.tpr -o $protein_file-sol2.trr -c $protein_file-sol2.gro -e $protein_file-sol1.edr -g $protein_file-sol1.log

for file in $protein_file-sol
do
{
  for number in 2 3 4 5 
  do
  {
    let num2=number+1
    if [ $number -eq 2 ]; then
      gmx grompp -f $file$number -c $file$number.gro -r $file$number.gro -n $file.ndx -p $file.top -o $file$number.tpr -maxwarn 2
    elif [ $number -eq 3 ]; then
      gmx grompp -f $file$number -c $file$number.gro -r $file$number.gro -t state.cpt -n $file.ndx -p $file.top -o $file$number.tpr -maxwarn 2
    elif [ $number -eq 4 ]; then
      gmx grompp -f $file$number -c $file$number.gro  -r $file$number.gro -t state.cpt -n $file.ndx -p $file.top -o $file$number.tpr -maxwarn 2
    elif [ $number -eq 5 ]; then
      gmx grompp -f $file$number -c $file$number.gro -t state.cpt -n $file.ndx -p $file.top -o $file$number.tpr -maxwarn 2
    fi
    gmx mdrun -s $file$number -o $file$num2.trr -c $file$num2.gro -e $file$number.edr -g $file$number.log 
  }
  done
}
done
