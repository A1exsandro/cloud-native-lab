provider "aws" {
  profile = "cloud-native-lab-wife"
  region  = "us-east-2"

  default_tags {
    tags = {
      Project     = "cloud-native-lab"
      Environment = "lab"
      ManagedBy   = "terraform"
    }
  }
}
