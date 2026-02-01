#importing packages
import json
import boto3
import os

table_name = os.environ['DYNAMODB_TABLE_NAME']
primary_key = 'id'
count_value = 'count'
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(table_name)
#function definition
def lambda_handler(event,context):
    try:
        #inserting values into table
        response = table.update_item(
        Key={
            primary_key : 'visitor_count'
        },
        UpdateExpression='SET #c = if_not_exists(#c, :zero) + :inc',
        ExpressionAttributeValues={
            ':inc': 1,
            ':zero': 0
        },
        ExpressionAttributeNames={
            '#c' : count_value
        },
        ReturnValues='UPDATED_NEW'
        )

        new_count = response['Attributes'][count_value]
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST',
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'message' : 'Count updated successfully',
                # 'current_count' : int(new_count)
            })
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json'
            },
            'body': json.dumps({
                'error': 'Internal server error'
            })
        }