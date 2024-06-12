aws iam create-policy --policy-name deny-services --policy-document file://../iam/deny-services-policy.json
aws iam attach-role-policy --role-name WSParticipantRole --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/deny-services
