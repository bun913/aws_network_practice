import base64
import json
import zlib
import os
import boto3

print('Loading function')


def lambda_handler(event, context):
    data = zlib.decompress(base64.b64decode(
        event['awslogs']['data']), 16+zlib.MAX_WBITS)
    data_json = json.loads(data)
    log_entire_json = json.loads(json.dumps(
        data_json["logEvents"], ensure_ascii=False))
    log_entire_len = len(log_entire_json)

    print(log_entire_json)

    for i in range(log_entire_len):
        log_json = json.loads(json.dumps(
            data_json["logEvents"][i], ensure_ascii=False))

        try:
            sns = boto3.client('sns')

            # SNS Publish
            publishResponse = sns.publish(
                TopicArn=os.environ['SNS_TOPIC_ARN'],
                Message=log_json['message'],
                Subject=os.environ['ALARM_SUBJECT']
            )

        except Exception as e:
            print(e)
