import boto3
import os

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Get bucket names from environment variables
    source_bucket = os.environ['SOURCE_BUCKET']
    backup_bucket = os.environ['BACKUP_BUCKET']
    
    # Get the newly uploaded file from the S3 event
    for record in event['Records']:
        key = record['s3']['object']['key']
        
        try:
            # Copy just the new file
            copy_source = {'Bucket': source_bucket, 'Key': key}
            s3.copy_object(
                Bucket=backup_bucket,
                Key=key,
                CopySource=copy_source
            )
            print(f"Successfully copied {key} to backup bucket")
        except Exception as e:
            print(f"Error copying {key}: {str(e)}")
            raise
    
    return {
        'statusCode': 200,
        'body': f"Copied {len(event['Records'])} files to backup"
    }