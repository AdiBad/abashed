#iterate over fna files and replace first line (where ">" is present) with their file names 
#filename is in the format strain_name.unicycler.fna
#!/bin/bash
for fil in $(ls *.fna)
do
    name=$(echo $fil | cut -d. -f1)
    name=">${name}"
    echo $name
    sed -i "s/>/${name}_/g" $fil;
done
