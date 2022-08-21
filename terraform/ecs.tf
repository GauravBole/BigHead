resource "aws_ecs_cluster" "airflow-cluster" {
  name = "airflow-cluster-tf"
  tags = {
    Name = "airflow-cluster-tf"
  }
}