# bastion host user-data
# install docker and run hello-world container
yum update -y
yum install docker -y
service docker start
service docker status

# add ec2-user to docker group to enable docker cli without sudo
usermod -a -G docker ec2-user
