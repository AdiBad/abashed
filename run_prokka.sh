#Run prokka for all genomes in a directory
#file name is of the format strain_name.unicycler.fasta
for k in *.fasta
do
name=${k%.*}
prokka $k --outdir Annotation_prokka/"$name".prokka --prefix annot_$name;
echo $name;
done
