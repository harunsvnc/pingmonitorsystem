#!/bin/bash
##dosyalar değişken olarak çağrılacak.

#####monitor.cfg den ipleri süz--
while read line;do 
if [[ $line =~ ^"#" ]]
 then
  continue 
  fi  
  echo "$line"|cut -d"|" -f2>> /tmp/ip.list; done<monitor.cfg
#####fpinge listeyi okut sonuçları pingresult'a yaz.
fping -C 3 -i5 -r2 -t 1000 -B4.0 -p 20000 -q -f /tmp/ip.list 2> pingresult.txt
####response timeları ilgili hostun adıyla oluşturulan dosyaya ekle
while read line; do ip=`echo $line | awk -F":" '{print $1}'`; echo "$line" | awk -F":" '{print $2}'>> /root/Desktop/data/$ip; done <pingresult.txt ;
##______________________________________________________________________________
###variables___
zaman=$(date +%x%X)

 
cat <<EOF >trial.html
<html>
	<head>
		 <link rel="stylesheet" type="text/css" href="html.css" />
		 

<!--#Ana Div Baslangic-->

<div id="ana_div">
EOF
   while read line; do
   if [[ $line =~ ^"#" ]]
 then
  continue 
  fi  
   ip=$(echo "$line"|cut -d"|" -f2);
   des=$(echo "$line"|cut -d"|" -f1);
   pingtimes=$(tail -1 /root/Desktop/data/$ip);
   dashcount=0;
   if [[ $pingtimes =~ "-" ]] 
   then
   dashcount=$(echo $pingtimes | grep -o "-" |wc -l);
   cr=3;
   
    if [[ $dashcount =~ ("1"|"2") ]] 
    then
        #bu kısım fonksiyon olarak yapılabilir kırmızı() gibi----
        
   echo "
    <div class="box" id="div">   
		<div class=\"bold left1\"> $des</div> 
		<div class=\"right1 c1\">$zaman </div>
		<div class=left2> $ip</div>   
		<div class=\"right2 cff7f00\">$pingtimes</div>   
		  </div>
     ">>trial.html
     else 
        echo "
    <div class=\"box\" id="div">   
		<div class=\"bold left1\"> $des</div> 
		<div class=right1>$zaman </div>
		<div class=left2> $ip</div>   
		<div class=\"right2 cff0000\">$pingtimes</div>   
		  </div>
     ">>trial.html
     fi
     else 
     echo "
    <div class="box" id="div">  
		<div class=\"bold left1\"> $des</div> 
		<div class=right1>$zaman </div>
		<div class=left2> $ip</div>   
		<div class=\"right2 c00ff00\">$pingtimes</div>   
		  </div>
     ">>trial.html
     fi
     
        done <monitor.cfg
 echo "</div>
<!--#Ana Div Bitis-->
</head>
</html>" >> trial.html
