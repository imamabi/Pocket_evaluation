# Pocket_evaluation
A quick druggable pocket identification and evaluation pipeline.

## Overview 

This repository provides a comprehensive pipeline for identifying and evaluating druggable pockets in proteins using molecular dynamics (MD) simulations, structure-based pocket detection tools, and physicochemical analyses. The workflow integrates various computational techniques to assess the stability, accessibility, and binding potential of protein pockets, enabling researchers to prioritize promising regions for drug discovery. 

The pipeline is designed to be modular, reproducible, and adaptable to different protein systems. It leverages tools such as GROMACS , Fpocket , H++ , and Python scripts for data analysis and visualization. 
     

## Installation 
### Prerequisites 
  - Python 3.x : Ensure Python is installed with necessary libraries (numpy, matplotlib, seaborn).
  - GROMACS : Install the [GROMACS](https://manual.gromacs.org/2024.4/install-guide/index.html) for molecular dynamics simulations.
  - Fpocket : Install [Fpocket](https://github.com/Discngine/fpocket/blob/master/doc/INSTALLATION.md) for druggable pocket detection.
  - [H++ Server](http://newbiophysics.cs.vt.edu/H++/): Accessible online for protonation state calculations.

System Preparation : 
     Obtain the initial protein structure 6UMV from the RCSB Protein Data Bank (PDB).
     Remove non-protein entities (e.g., water, ligands, ions).
     Use the H++ server to assign correct protonation states at physiological pH.
         

    Pocket Detection : 
Run Fpocket to identify and evaluate druggable pockets based on geometric and physicochemical properties (e.g., volume, hydrophobicity, druggability score).
         

    Molecular Dynamics Simulation : 
        Solvate the system using the TIP3P water model.
        Neutralize the system with counterions and set physiological ionic strength.
        Perform energy minimization, equilibration (NVT and NPT), and production MD using the AMBER14SB force field.
         

    Post-Simulation Analysis : 
        Calculate RMSD and RMSF to assess protein stability and residue flexibility.
        Compute SASA for heavy atoms in identified pockets to evaluate solvent accessibility.
        Analyze trajectories to understand conformational dynamics.
         

    Visualization and Reporting : 
        Generate plots (e.g., RMSD, RMSF, SASA) and summaries to interpret results.
        Highlight key findings, such as the most druggable pocket and its characteristics.
         
     
