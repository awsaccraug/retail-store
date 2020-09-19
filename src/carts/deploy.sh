#!/bin/sh
echo "Checking S3 bucket exists..."                                                                                                                                                                                                           
BUCKET_EXISTS=true
BUCKET_NAME="retail-store-deployment-ur9utvmxjwu51t8gyfodw"                                                                                                                                                                                                                            
S3_CHECK=$(aws s3 ls "s3://${BUCKET_NAME}" 2>&1)                                                                                                              

#Some sort of error happened with s3 check                                                                                                                                                                                                    
if [ $? != 0 ]                                                                                                                                                                                                                                
then                                                                                                                                                                                                                                          
  NO_BUCKET_CHECK=$(echo $S3_CHECK | grep -c 'NoSuchBucket')                                                                                                                                                                                     
  if [ $NO_BUCKET_CHECK = 1 ]; then                                                                                                                                                                                                              
    echo "Bucket does not exist"                                                                                                                                                                                                              
    BUCKET_EXISTS=false
    # Creates your deployment bucket if it doesn't exist yet.
    aws s3 mb s3://$BUCKET_NAME                 
    # Uploads files to S3 bucket and creates CloudFormation template
    sam package --template-file template.yaml --s3-bucket $BUCKET_NAME --output-template-file package.yaml

    # Deploys your stack
    sam deploy --template-file package.yaml --stack-name carts-stack --capabilities CAPABILITY_IAM
    
  else                                                                                                                                                                                                                                        
    echo "Error checking S3 Bucket"                                                                                                                                                                                                           
    echo "$S3_CHECK"                                                                                                                                                                                                                          
    exit 1                                                                                                                                                                                                                                    
  fi
else                                                                                                                                                                                                                                      
  echo "Bucket exists"
  # Uploads files to S3 bucket and creates CloudFormation template
  sam package --template-file template.yaml --s3-bucket $BUCKET_NAME --output-template-file package.yaml

  # Deploys your stack
  sam deploy --template-file package.yaml --stack-name carts-stack --capabilities CAPABILITY_IAM

fi
