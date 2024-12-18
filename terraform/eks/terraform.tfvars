# AWS account config
region = "eu-central-1"

# General for all infrastructure
# This is the name prefix for all infra components
name = "danit"


#vpc_id      = "vpc-06ae62935ffb33e2b"
#subnets_ids = ["subnet-0b27929ad2896d99f", "subnet-0c15a8c6856de7853", "subnet-01a5c422124b1c69e"]


vpc_id      = "vpc-0bf96b3dd9f5532b0"
subnets_ids = ["subnet-0aa2407d25e2542d0", "subnet-02966d02e563a4b29", "subnet-08d6fa0614f965eb4"]

tags = {
  Environment = "A3888S"
  TfControl   = "true"
}

zone_name = "a3888s.test-danit.com"
