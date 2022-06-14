terraform {
  required_version = ">= 0.14"

  required_providers {
    # Cloud Run support was added on 3.3.0
    google = ">= 4.24.0"
  }
}

provider "google" {
  # Replace `PROJECT_ID` with your project
  project = "erudite-bonbon-324020"
  region  = "us-east1"
}