for i in $(cat roles)
	do aws iam create-role --role-name $i --assume-role-policy-document file://role.json
done
