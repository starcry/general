echo > all_files.txt
for i in $(find -name "*.lua"); do
  echo '########################################################' >> all_files.txt
  echo "########### $i  ########################################" >> all_files.txt
  cat $i >> all_files.txt
  echo '########################################################' >> all_files.txt
  echo >> all_files.txt
  echo >> all_files.txt
  echo >> all_files.txt
done
