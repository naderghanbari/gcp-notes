provider "google" {
  credentials = "~/.config/gcp-creds/playground.json"
  project     = "playground-256017"
  region      = "northamerica-northeast1"
  zone        = "northamerica-northeast1-c"
}
