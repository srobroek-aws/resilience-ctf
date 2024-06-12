aws iam create-policy --policy-name deny-fis --policy-document file://../iam/deny-fis-policy.json
aws iam attach-role-policy --role-name WSParticipantRole --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/deny-fis
