
series{
  title="FPM1"
  file="monthly.csv"
  format="free"
  start=2001.1
  span=(2001.1 2016.3)
  period=4
  save=a1
}

outlier{ types=all }
automdl{ print=ach }
seats{ print=s12
       save=s12 }

