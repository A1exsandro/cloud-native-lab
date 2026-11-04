provider "aws" {
  profile = "cloud-native-lab"
  region  = "sa-east-1"

  default_tags {
    tags = {
      Project     = "cloud-native-lab"
      Environment = "lab"
      ManagedBy   = "terraform"
    }
  }
}
