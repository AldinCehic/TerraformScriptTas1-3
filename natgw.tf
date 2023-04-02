# Create a Internet Gateway
resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "main"
  }
}
