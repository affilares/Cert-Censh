echo "-----------------------------------------------------"

echo "Enter your domain example.com":
	read domain

echo "Enter your censys.io api id and secret key for later use :"

echo "Enter you api id:"
	read api

echo "Enter your api secret:"
	read secret

echo "-----------------------------------------------------"

clear ; 

echo "We begin harvesting all ids for your input domain "

## Get all the IDs from crt_sh and store it into a file 

curl -s https://crt.sh/?q=%25.$domain |grep "href=" |cut -d "\"" -f 4|grep "?id=" |tee all_id.$domain

echo "done and you file name is all_id.$domain ..."


## Now for every ID we will get the hash and store them into a file 

echo "Now we are harvesting all hashes"

for i in `cat all_id.$domain` 
	do 
		curl -s https://crt.sh/$i |grep "censys" |cut -d ">" -f 3 |cut -d "<" -f 1 |tee -a all_hash.$domain
	done ;
echo "done and your file name is all_hashe.$domain"

echo "Now we will search on the censys.io Note that the output will be saved into a file "

echo "What type you like to finde (ipv4|certs|websites)"
	read type
	
for i in `cat all_hash.$domain`
	do 
		query=`censys --query_type $type --censys_api_id $api --censys_api_secret $secret $i`
		if [[ $query == "[]" ]]
			then
				echo "We do not found anything here ==> " $query
 
		else 		echo "-------------------------------------------" >> file.txt	
				echo $query >> censys_$type_$domain
				echo "-------------------------------------------" >> file.txt 
				echo "There is some thing here ==> " $i
		fi
done ;
