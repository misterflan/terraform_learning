provider "google" {
  credentials   = "${file("cr-lab-rcunningham-0108193555-3b30a9865358.json")}"
  project       = "cr-lab-rcunningham-0108193555"
  region        = "europe-west2"
  zone          = "europe-west2-c"
}

resource "google_compute_instance" "vm_instance" {
    name        = "terraform-instance"
    machine_type    = "f1-micro"
  
    boot_disk {
        initialize_params {
            image   = "debian-cloud/debian-9"
        }
    }
    network_interface {
        network = "${google_compute_network.vpc_network.self_link}"
        access_config {}
    }
    metadata = {
        ssh-keys = "richardcunningham:${file("~/.ssh/id_rsa.pub")}"
    }
}

resource "google_compute_network" "vpc_network" {
    name        = "terraform-network"
    auto_create_subnetworks = "true"
  
}

resource "google_compute_firewall" "default" {
    name = "terraform-network-firewall"
    network = "terraform-network"

    allow {
        protocol = "tcp"
        ports   = ["22"]
    }
  
}


