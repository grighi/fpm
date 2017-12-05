# clean up

if [ ! -d logs ]; 
  then mkdir logs; 
fi
mv *.log logs/

if [ ! -d dofiles ]; 
  then mkdir dofiles; 
fi
mv *.{do,dct} dofiles/

rm {*.smcl,*.zip,*.zip.*,*.dat}

rename cpsmar20 cpsmar *

mv cpsmar* ../inputs





