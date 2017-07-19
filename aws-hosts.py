from collections import defaultdict
import yaml
import boto3

# function to create host sls files
def createHostSls(host_info_str):
    host_info = host_info_str.split(":")
    name = host_info[0]
    ipAddr = host_info[1]
    filename = "aws-hosts//"+name+'.sls'

    #if the hostname or ip is not present at all do this
    d = {name:{'host.present':{'ip':ipAddr}}}

    with open(filename, 'w') as yaml_file:
        yaml.dump(d, yaml_file, default_flow_style=False)

# main function        
def main():
    # Connect to EC2
    ec2 = boto3.resource('ec2')
    
    # Get information for all running instances
    running_instances = ec2.instances.filter(Filters=[{
        'Name': 'instance-state-name',
        'Values': ['running']}])
    
    ec2info = defaultdict()
    for instance in running_instances:
        # Find the 'Name' tag
        for tag in instance.tags:
            if 'Name'in tag['Key']:
                name = tag['Value']
        # Add instance info to a dictionary         
        ec2info[instance.id] = {
            'Name': name,
            'Type': instance.instance_type,
            'State': instance.state['Name'],
            'Private IP': instance.private_ip_address,
            'Public IP': instance.public_ip_address,
            'Launch Time': instance.launch_time
            }
    
    attributes = ['Name', 'Private IP']
    for instance_id, instance in ec2info.items():
        hostInfoString = None
        for key in attributes:
            if hostInfoString is None:
                hostInfoString = "{1}".format(key, instance[key])
            else:
                hostInfoString = hostInfoString +':'+"{1}".format(key, instance[key])
        createHostSls(hostInfoString)
 
main()
