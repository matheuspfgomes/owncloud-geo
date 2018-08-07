provider "google" {
    credentials = "${file("GCP-key.json")}"
    project = "geofusion-212223"
    region = "us-east1"
}
