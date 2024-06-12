aws iam create-policy --policy-name deny-fis --policy-document file://../iam/deny-fis-policy
aws iam attach-role-policy --role-name WSParticipantRole --policy-arn arn:aws:iam::aws:policy/deny-fis
