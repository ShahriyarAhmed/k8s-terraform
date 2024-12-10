resource "google_artifact_registry_repository" "my-repo" {
  count=var.num_of_repo
  location      = "europe-west1"
  repository_id = "${var.name[count.index]}-repo"
  description   = "${var.name[count.index]} repository"
  format        = "DOCKER"
  docker_config {
    immutable_tags = true
  }
}